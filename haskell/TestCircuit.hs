{-|
  Module      : Test
  Description : Just tests some test circuits
  Copyright   : (c) Emilio Wuerges, 2016
  License     : BSD-3
  Maintainer  : wuerges@gmail.com
  Stability   : experimental
  Portability : POSIX

-}

module TestCircuits where

import CLaSH.Prelude
import CLaSH.Sized.Vector

test1 :: Signal (Unsigned 8) -> Signal (Unsigned 8)
test1 a = register 0 $ a + 1

topEntity = test1 . test1 . test1
