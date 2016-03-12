module Blinker where

import CLaSH.Prelude

counter :: (Num a, Eq a) => a -> Signal Bool
counter m = wrap
    where
        s = register 0 $ mux wrap 0 (s + 1)
        wrap = s .==. signal m

blinker :: Signal Bool -> Signal Bool
blinker i = s
    where s = register False $ i ./=. s

{-# ANN topEntity
    (defTop
        { t_name     = "blinkLeds"
        , t_inputs   = []
        , t_outputs  = ["LEDG"]
        , t_extraIn  = []
        , t_clocks   = []
        }) #-}
topEntity :: Signal Bool
topEntity = blinker $ counter (50 * 1024 * 1024 :: Unsigned 26)
--topEntity = blinker $ counter (50 :: Unsigned 26)

