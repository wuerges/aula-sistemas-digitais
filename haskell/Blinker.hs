module Blinker where

import CLaSH.Prelude


-- register :: a -> Signal a -> Signal a
--


counter :: (Num a, Eq a) => a -> Signal Bool -> Signal Bool
counter m e = s .==. (signal m)
    where
        s = regEn 0 e (s + 1)


counter10 :: Signal Bool -> Signal Bool
counter10 = counter (50 * 1024 * 1024 :: Unsigned 26)


topEntity :: Signal Bool -> Signal Bool
topEntity = counter10

