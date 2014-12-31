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
  , showTemplateType'
  , showQueryAtom
  , showQueryAtom'
  , showQuery
  )
  where

import Data.Data (Data(toConstr), showConstr)
import Data.Function ((.), ($))
import qualified Data.List as List (map)
import Data.Maybe (Maybe(Just, Nothing))
import Data.Monoid (Monoid(mempty), (<>))
import Text.Show (Show(show))

import Data.CaseInsensitive (CI)
import qualified Data.CaseInsensitive as CI (foldedCase, map, mk)
import Data.Text (Text)
import Data.Text as Text (concatMap, pack, singleton, unwords)

import Control.Lens ((^?), (^.), view)
import Data.Maybe.Strict (_Just)

import Skeletos.Internal.Utils (dropSuffix)
import Skeletos.Type.Define
import Skeletos.Type.Query (Query, QueryAtom(..), queryAtoms)
import Skeletos.Type.TemplateType (TemplateType)


showDefine :: Define -> Text
showDefine d = "-D" <> (d ^. name) <> case d ^? value . _Just of
    Nothing -> mempty
    Just v  -> Text.singleton '=' <> case v of
        TextValue t -> "\"text:" <> escape t <> "\""
        BoolValue b -> "bool:"   <> if b then "true" else "false"
        IntValue i  -> "int:"    <> Text.pack (show i)
        WordValue w -> "word:"   <> Text.pack (show w)

showTemplateType :: TemplateType -> Text
showTemplateType = CI.foldedCase . showTemplateType'

showTemplateType' :: TemplateType -> CI Text
showTemplateType' = CI.mk . Text.pack . showConstr . toConstr

showQueryAtom :: QueryAtom -> Text
showQueryAtom = CI.foldedCase . showQueryAtom'

showQueryAtom' :: QueryAtom -> CI Text
showQueryAtom' q = atomName <> eq <> case q of
    TypeAtom x     -> showTemplateType' x
    LanguageAtom x -> ciTextContent x
    TagAtom x      -> ciTextContent x
  where
    ciTextContent = CI.map escape
    atomName = CI.mk
        . Text.pack
        . dropSuffix "Atom"
        . showConstr $ toConstr q
    eq = CI.mk (Text.singleton '=')

showQuery :: Query -> Text
showQuery = Text.unwords . List.map showQueryAtom . view queryAtoms

escape :: Text -> Text
escape = concatMap $ \ch -> case ch of
    '"'  -> "\\\""
    '$'  -> "\\$"
    ' '  -> "\\ "
    '\'' -> "\\'"
    _    -> Text.singleton ch

--showQueryAtom :: QueryAtom
