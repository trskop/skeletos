{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
-- |
-- Module:       $HEADER$
-- Description:  TODO
-- Copyright:    (c) 2014 Peter Trsko
-- License:      BSD3
--
-- Maintainer:   peter.trsko@gmail.com
-- Stability:    experimental
-- Portability:  NoImplicitPrelude, OverloadedStrings
--
-- TODO
module Skeletos.ShowOpt
  (
    showDefine
  , showTemplateType
  )
  where

import qualified Data.Char as Char (toLower)
import Data.Data (Data(toConstr), showConstr)
import Data.Function ((.), ($))
import qualified Data.List as List (map)
import Data.Maybe (Maybe(Just, Nothing))
import Data.Monoid (Monoid(mempty), (<>))
import Text.Show (Show(show))

import Data.Text (Text)
import Data.Text as Text (concatMap, pack, singleton)

import Control.Lens ((^?), (^.))
import Data.Maybe.Strict (_Just)

import Skeletos.Type.Define
import Skeletos.Type.TemplateType (TemplateType)


showDefine :: Define -> Text
showDefine d = "-D" <> (d ^. name) <> case d ^? value . _Just of
    Nothing -> mempty
    Just v  -> Text.singleton '=' <> case v of
        TextValue t -> "\"text:" <> escape t <> "\""
        BoolValue b -> "bool:"   <> if b then "true" else "false"
        IntValue i  -> "int:"    <> Text.pack (show i)
        WordValue w -> "word:"   <> Text.pack (show w)
  where
    escape = concatMap $ \ch -> case ch of
        '"' -> "\\\""
        '$' -> "\\$"
        _   -> Text.singleton ch

showTemplateType :: TemplateType -> Text
showTemplateType = Text.pack . List.map Char.toLower . showConstr . toConstr
