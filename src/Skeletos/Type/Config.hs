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
module Skeletos.Type.Config
--  (
--  )
  where

import Data.Data (Data)
import Data.Typeable (Typeable)
import GHC.Generics (Generic)
import Text.Read (Read)
import Text.Show (Show)

import Control.Lens (Lens')
import Data.Default.Class (Default(def))

import Skeletos.Internal.Utils ((<$$>))
import Skeletos.Type.Query (Query)
import Skeletos.Type.Define (Defines)


data Config = Config
    { _query   :: Query
    , _defines :: Defines
    }
  deriving (Data, Generic, Read, Show, Typeable)

-- | Defined as:
--
-- @
-- 'def' = 'Config'
--     { '_query'   = 'def'
--     , '_defines' = 'def'
--     }
-- @
instance Default Config where
    def = Config
        { _query   = def
        , _defines = def
        }

query :: Lens' Config Query
query f s@Config{_query = a} = f a <$$> \b -> s{_query = b}

defines :: Lens' Config Defines
defines f s@Config{_defines = a} = f a <$$> \b -> s{_defines = b}
