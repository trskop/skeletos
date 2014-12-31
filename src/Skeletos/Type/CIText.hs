{-# LANGUAGE NoImplicitPrelude #-}
-- |
-- Module:       $HEADER$
-- Description:  Type alias for case insensitive strict text.
-- Copyright:    (c) 2014 Peter Trsko
-- License:      BSD3
--
-- Maintainer:   peter.trsko@gmail.com
-- Stability:    experimental
-- Portability:  NoImplicitPrelude
--
-- Type alias for case insensitive strict text.
module Skeletos.Type.CIText (CIText)
  where

import Data.CaseInsensitive (CI)
import qualified Data.Text as Strict (Text)


-- | Case insensitive strict 'Strict.Text'.
type CIText = CI Strict.Text
