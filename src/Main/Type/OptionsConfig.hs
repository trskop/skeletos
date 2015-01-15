{-# LANGUAGE NoImplicitPrelude #-}
-- |
-- Module:       $HEADER$
-- Description:  TODO
-- Copyright:    (c) 2014, 2015 Peter Trsko
-- License:      BSD3
--
-- Maintainer:   peter.trsko@gmail.com
-- Stability:    experimental
-- Portability:  NoImplicitPrelude
--
-- TODO
module Main.Type.OptionsConfig
    ( OptionsConfig(..)
    , variableDefines
    , templateSearchQuery
    , outputFile
    )
  where

import Data.Maybe (Maybe(Nothing))
import System.IO (FilePath)
import Text.Show (Show)

import Control.Lens (Lens', lens)
import Data.Default.Class (Default(def))

import Skeletos.Type.Define (Define)
import Skeletos.Type.Query (QueryAtom)


data OptionsConfig = OptionsConfig
    { _variableDefines :: [Define]
    , _outputFile :: Maybe FilePath
    -- ^ Is either 'Data.Maybe.Nothing' or 'Data.Maybe.Just' non-empty string.
    -- Invariant of non-empty string is preserved by 'filePath' parser.
    , _templateSearchQuery :: [QueryAtom]
    }
  deriving (Show)

instance Default OptionsConfig where
    def = OptionsConfig
        { _variableDefines     = []
        , _outputFile          = Nothing
        , _templateSearchQuery = []
        }

variableDefines :: Lens' OptionsConfig [Define]
variableDefines = _variableDefines `lens` \s b -> s{_variableDefines = b}

outputFile :: Lens' OptionsConfig (Maybe FilePath)
outputFile = _outputFile `lens` \s b -> s{_outputFile = b}

templateSearchQuery :: Lens' OptionsConfig [QueryAtom]
templateSearchQuery =
    _templateSearchQuery `lens` \s b -> s{_templateSearchQuery = b}
