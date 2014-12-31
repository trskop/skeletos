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
--  (
--  )
  where

import Data.Data (Data)
import Data.Typeable (Typeable)
import GHC.Generics (Generic)
import Text.Read (Read)
import Text.Show (Show)

import Data.Default.Class (Default(def))


data Query = Query
  deriving (Data, Generic, Read, Show, Typeable)

instance Default Query where
    def = Query
