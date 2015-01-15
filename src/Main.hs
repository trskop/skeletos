{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE NoImplicitPrelude #-}
-- |
-- Module:       $HEADER$
-- Description:  TODO
-- Copyright:    (c) 2014, 2015 Peter Trsko
-- License:      BSD3
--
-- Maintainer:   peter.trsko@gmail.com
-- Stability:    experimental
-- Portability:  DeriveDataTypeable, NoImplicitPrelude
--
-- TODO
module Main (main)
  where

import Control.Monad (Monad(return))
import Data.Either (Either(Left, Right))
import Data.Function ((.), ($))
import qualified Data.List as List (null, unwords)
import Data.Maybe (Maybe(Just, Nothing))
import Data.Monoid (Monoid(mconcat))
import Data.String (String)
import Data.Version (showVersion)
import System.IO (IO, hPutStrLn, print, stderr)

import Control.Monad.Trans.Identity (IdentityT(IdentityT, runIdentityT))
import Data.Text (Text)
import qualified Data.Text.IO as Text (putStr, writeFile)

import Control.Lens ((^.), (.~), (&), (%~), set, view)
import Data.Default.Class (Default(def))
import Data.Monoid.Endo (E, runEndo)
import Data.Monoid.Endo.Fold ((<&$>), (&$), foldEndo)
import Options.Applicative

import Skeletos.Parse (parseDefine, parseQueryAtom)
import Skeletos.Type.Config (Config)
import qualified Skeletos.Type.Config as Config (defines, query)
import Skeletos.Type.Define (defines)
import Skeletos.Type.Query (queryAtoms)

import Main.Type.OptionsConfig
    ( OptionsConfig
    , variableDefines
    , outputFile
    , templateSearchQuery
    )
import Paths_skeletos (version)


getSkeletosConfig :: OptionsConfig -> Config
getSkeletosConfig optcfg = def
    & Config.defines . defines    .~ view variableDefines optcfg
    & Config.query   . queryAtoms .~ view templateSearchQuery optcfg

options :: Parser OptionsConfig
options = runIdentityT $ runEndo def <&$> foldEndo
    <*> IdentityT defineOption
    <*> IdentityT outputFileOption
    <*> IdentityT queryArgument

defineOption :: Parser [E OptionsConfig]
defineOption = many . option define $ mconcat
    [ short 'D'
    , metavar "VARIABLE[=[TYPE:]VALUE]"
    , help "Define a variable with optional (typed) value."
    ]
  where
    define = addDefine <$> eitherReader parseDefine
    addDefine d = variableDefines %~ (d :)

outputFileOption :: Parser (Maybe (E OptionsConfig))
outputFileOption = optional . option filePath $ mconcat
    [ short 'o'
    , metavar "FILE"
    , help $ List.unwords
        [ "Store output in to a file, if supported by template type,"
        , "instead of printing it to a stdout."
        ]
    ]
  where
    filePath = set outputFile
        <$> nonEmptyStr "Option argument can not be empty file path."

    nonEmptyStr msg = eitherReader $ \s ->
        if List.null s
            then Left msg
            else Right (Just s)

queryArgument :: Parser [E OptionsConfig]
queryArgument = some . argument queryAtom &$ metavar "QUERY"
    <> help (List.unwords
        [ "Query consisting of one or multiple key=value pairs for"
        , "selecting specific template."
        ])
  where
    queryAtom = addQueryAtom <$> eitherReader parseQueryAtom
    addQueryAtom a = templateSearchQuery %~ (a :)

main :: IO ()
main = do
    appConfig <- execParser (info parser infoMod)
    r <- skeletos $ getSkeletosConfig appConfig
    case r of
        Left msg         -> hPutStrLn stderr msg
        Right Nothing    -> return ()
        Right (Just out) -> case appConfig ^. outputFile of
            Nothing   -> Text.putStr out
            Just file -> Text.writeFile file out
  where
    parser = helper <*> versioner <*> options

    infoMod = fullDesc
        <> progDesc "Create skeleton project, file or code snippet from a template."
        <> header (List.unwords ["skeletos", versionStr])
        <> footer (List.unwords
            [ "QUERY syntax:"
            , "type={package|file|snippet}"
            , "[language=STRING]"
            , "[tag=STRING ...]"
            ])

    versioner = abortOption (InfoMsg versionStr) $ mconcat
        [ long "version"
        , short 'V'
        , help "Show version number and exit."
        , hidden
        ]

    versionStr = showVersion version

    -- Temporary:
    skeletos :: Config -> IO (Either String (Maybe Text))
    skeletos = (Right Nothing <$) . print
