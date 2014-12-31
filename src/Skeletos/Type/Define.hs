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
-- Portability:  DeriveDataGeneric, DeriveDataTypeable, NoImplicitPrelude
--
-- TODO
module Skeletos.Type.Define
    (
    -- * Data Types
      Define(..)
    , Value(..)

    -- * Lenses
    , name
    , value

    -- * Prisms
    , boolValue
    , textValue
    , intValue
    , wordValue
    )
  where

import Data.Bool (Bool)
import Data.Data (Data)
import Data.Function (($))
import Data.Int (Int)
import Data.Maybe (Maybe(Just, Nothing))
import Data.Typeable (Typeable)
import Data.Word (Word)
import GHC.Generics (Generic)
import Text.Read (Read)
import Text.Show (Show)

import Data.Text (Text)
import qualified Data.Text as Text (empty)

import Control.Lens (Lens', Prism', prism')
import qualified Data.Maybe.Strict as Strict (Maybe(Nothing))
import Data.Default.Class (Default(def))

import Skeletos.Internal.Utils ((<$$>))


data Value
    = BoolValue !Bool
    | TextValue !Text
    | IntValue !Int
    | WordValue !Word
  deriving (Data, Generic, Read, Show, Typeable)

boolValue :: Prism' Value Bool
boolValue = prism' BoolValue $ \v -> case v of
    BoolValue x -> Just x
    _           -> Nothing

textValue :: Prism' Value Text
textValue = prism' TextValue $ \v -> case v of
    TextValue x -> Just x
    _           -> Nothing

intValue :: Prism' Value Int
intValue = prism' IntValue $ \v -> case v of
    IntValue x -> Just x
    _          -> Nothing

wordValue :: Prism' Value Word
wordValue = prism' WordValue $ \v -> case v of
    WordValue x -> Just x
    _           -> Nothing

data Define = Define
    { _name :: !Text
    , _value :: Strict.Maybe Value
    }
  deriving (Data, Generic, Read, Show, Typeable)

instance Default Define where
    def = Define
        { _name = Text.empty
        , _value = Strict.Nothing
        }

name :: Lens' Define Text
name f s@Define{_name = a} = f a <$$> \b -> s{_name = b}

value :: Lens' Define (Strict.Maybe Value)
value f s@Define{_value = a} = f a <$$> \b -> s{_value = b}
