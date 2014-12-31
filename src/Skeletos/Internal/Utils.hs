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
    , dropPrefix
    , dropSuffix
    )
  where

import Data.Bool (otherwise)
import Data.Eq (Eq((/=)))
import Data.Function (($), flip)
import Data.Functor (Functor(fmap))
import qualified Data.List as List (reverse)


(<$$>) :: Functor f => f a -> (a -> b) -> f b
(<$$>) = flip fmap
infixr 4 <$$>

dropPrefix :: Eq a => [a] -> [a] -> [a]
dropPrefix []     str        = str
dropPrefix _      str@[]     = str
dropPrefix (x:xs) str@(y:ys)
  | x /= y                   = str
  | otherwise                = dropPrefix xs ys

dropSuffix :: Eq a => [a] -> [a] -> [a]
dropSuffix sfx str =
    List.reverse $ dropPrefix (List.reverse sfx) (List.reverse str)
