module Blinker where

import CLaSH.Prelude

counter :: (Num a, Eq a) => a -> Signal Bool -> Signal Bool
counter m e = s .==. (signal m)
    where
        s = regEn 0 e (s + 1)

blinker :: Signal Bool -> Signal Bool
blinker i = s
    where s = register False $ i ./=. s

topEntity :: Signal Bool -> Signal Bool
topEntity = counter (50 * 1024 * 1024 :: Unsigned 26) . blinker

