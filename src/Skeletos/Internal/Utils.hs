{-# LANGUAGE NoImplicitPrelude #-}
-- |
-- Module:       $HEADER$
-- Description:  TODO
-- Copyright:    (c) 2014 Peter Trsko
-- License:      BSD3
--
-- Maintainer:   peter.trsko@gmail.com
-- Stability:    experimental
-- Portability:  NoImplicitPrelude
--
-- TODO
module Skeletos.Internal.Utils
    ( (<$$>)
    )
  where

import Data.Function (flip)
import Data.Functor (Functor(fmap))


(<$$>) :: Functor f => f a -> (a -> b) -> f b
(<$$>) = flip fmap
infixr 4 <$$>
