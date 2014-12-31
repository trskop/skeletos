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
module Skeletos.Type.TemplateType
--  (
--  )
  where

import Prelude (Bounded, Enum)

import Data.Data (Data)
import Data.Eq (Eq)
import Data.Ord (Ord)
import Data.Typeable (Typeable)
import GHC.Generics (Generic)
import Text.Read (Read)
import Text.Show (Show)


data TemplateType = Package | File | Snippet
  deriving (Bounded, Data, Enum, Eq, Generic, Ord, Read, Show, Typeable)
