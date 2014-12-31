{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE NoImplicitPrelude #-}
-- |
-- Module:       $HEADER$
-- Description:  TODO
-- Copyright:    (c) 2014 Peter Trsko
-- License:      BSD3
--
-- Maintainer:   peter.trsko@gmail.com
-- Stability:    experimental
-- Portability:  DeriveDataTypeable, DeriveGeneric, NoImplicitPrelude
--
-- TODO
module Skeletos.Type.Query
    (
      Query(..)
    , QueryAtom(..)
    , queryAtoms
    , typeAtom
    , languageAtom
    , tagAtom
    )
  where

import Data.Data (Data)
import Data.Eq (Eq)
import Data.Function (($))
import Data.Functor ((<$>))
import Data.Maybe (Maybe(Just, Nothing))
import Data.Typeable (Typeable)
import GHC.Generics (Generic)
import Text.Read (Read)
import Text.Show (Show)

import Control.Lens (Lens', Prism', prism')
import Data.Default.Class (Default(def))

import Skeletos.Type.CIText (CIText)
import Skeletos.Type.TemplateType (TemplateType)


data QueryAtom
    = TypeAtom !TemplateType
    | LanguageAtom CIText
    | TagAtom CIText
  deriving (Data, Eq, Generic, Read, Show, Typeable)

-- | 'Prism'' for 'TypeAtom'.
typeAtom :: Prism' QueryAtom TemplateType
typeAtom = prism' TypeAtom $ \s -> case s of
    TypeAtom x -> Just x
    _          -> Nothing

-- | 'Prism'' for 'LanguageAtom'.
languageAtom :: Prism' QueryAtom CIText
languageAtom = prism' LanguageAtom $ \s -> case s of
    LanguageAtom x -> Just x
    _              -> Nothing

-- | 'Prism'' for 'TagAtom'.
tagAtom :: Prism' QueryAtom CIText
tagAtom = prism' TagAtom $ \s -> case s of
    TagAtom x -> Just x
    _         -> Nothing

newtype Query = Query [QueryAtom]
  deriving (Data, Eq, Generic, Read, Show, Typeable)

-- | Defined as:
--
-- @
-- 'def' = 'Query' '[]'
-- @
instance Default Query where
    def = Query []

queryAtoms :: Lens' Query [QueryAtom]
queryAtoms f (Query a) = Query <$> f a
