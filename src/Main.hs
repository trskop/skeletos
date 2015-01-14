{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE RecordWildCards #-}
-- |
-- Module:       $HEADER$
-- Description:  TODO
-- Copyright:    (c) 2014, 2015 Peter Trsko
-- License:      BSD3
--
-- Maintainer:   peter.trsko@gmail.com
-- Stability:    experimental
-- Portability:  DeriveDataTypeable, NoImplicitPrelude, RecordWildCards
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
import System.IO (FilePath, IO, hPutStrLn, print, stderr)
import Text.Show (Show)

import Data.Text (Text)
import qualified Data.Text.IO as Text (putStr, writeFile)

import Control.Lens ((.~), (&))
import Data.Default.Class (Default(def))
import Options.Applicative

import Skeletos.Parse (parseDefine, parseQueryAtom)
import Skeletos.Type.Config (Config)
import qualified Skeletos.Type.Config as Config (defines, query)
import Skeletos.Type.Define (Define, defines)
import Skeletos.Type.Query (QueryAtom, queryAtoms)

import Paths_skeletos (version)


data OptionsConfig = OptionsConfig
    { variableDefines :: [Define]
    , outputFile :: Maybe FilePath
    -- ^ Is either 'Data.Maybe.Nothing' or 'Data.Maybe.Just' non-empty string.
    -- Invariant of non-empty string is preserved by 'filePath' parser.
    , templateSearchQuery :: [QueryAtom]
    }
  deriving (Show)

instance Default OptionsConfig where
    def = OptionsConfig
        { variableDefines     = []
        , outputFile          = Nothing
        , templateSearchQuery = []
        }

getSkeletosConfig :: OptionsConfig -> Config
getSkeletosConfig OptionsConfig{..} = def
    & Config.defines . defines    .~ variableDefines
    & Config.query   . queryAtoms .~ templateSearchQuery

options :: Parser OptionsConfig
options = OptionsConfig
    <$> (many . option (eitherReader parseDefine) . mconcat)
        [ short 'D'
        , metavar "VARIABLE[=[TYPE:]VALUE]"
        , help "Define a variable with optional (typed) value."
        ]
    <*> (optional . option filePath . mconcat)
        [ short 'o'
        , metavar "FILE"
        , help $ List.unwords
            [ "Store output in to a file, if supported by template type,"
            , "instead of printing it to a stdout."
            ]
        ]
    <*> (some . argument (eitherReader parseQueryAtom))
        ( metavar "QUERY"
        <> help (List.unwords
            [ "Query consisting of one or multiple key=value pairs for"
            , "selecting specific template."
            ])
        )
  where
    filePath = nonEmptyStr "Option argument can not be empty file path."
    nonEmptyStr msg = eitherReader $ \s ->
        if List.null s
            then Left msg
            else Right s

main :: IO ()
main = do
    appConfig <- execParser (info parser infoMod)
    r <- skeletos $ getSkeletosConfig appConfig
    case r of
        Left msg         -> hPutStrLn stderr msg
        Right Nothing    -> return ()
        Right (Just out) -> case outputFile appConfig of
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
