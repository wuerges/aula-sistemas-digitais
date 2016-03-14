module Triangle where

import CLaSH.Prelude
import TriangleTypes

{-
uts :: Signal (Unsigned 10) -> Signal (Signed 11)
uts n = resize . bitCoerce <$> n


sign :: Signal P -> Signal P -> Signal P -> Signal Bool
sign p1 p2 p3 = s1 .<. s2
    where
        s1 =         (uts (fst up1) `minus` uts (fst up3))
             `times` (uts (snd up2) `minus` uts (snd up3))
        s2 =         (uts (fst up2) `minus` uts (fst up3))
             `times` (uts (snd up1) `minus` uts (snd up3))

        up1 = unbundle p1
        up2 = unbundle p2
        up3 = unbundle p3

insideT :: Signal T -> Signal P -> Signal Bool
insideT t pt =
        sign pt v1 v2 .&&. sign pt v2 v3 .&&. sign pt v3 v1
    where (v1, v2, v3) = unbundle t

triangleTester :: Signal P  -> T -> Signal Bool
triangleTester s t = insideT (signal t) s

triangleTesters :: Signal P -> Signal Bool
triangleTesters s = fold (.&.) $ map (triangleTester s) ts

counters :: (Num a, Eq a) => a -> a -> Signal (a, a)
counters mx my = bundle (x, y)
    where
        x = register 0 $ mux wx 0 (x + 1)
        y = register 0 $ mux wx (mux wy 0 (y + 1)) y
        wx = x .==. signal mx
        wy = y .==. signal my

counters10 :: Unsigned 10 -> Unsigned 10 -> Signal P
counters10 = counters

topTester :: Signal P -> Signal Bool
topTester = triangleTesters

{-# ANN topEntity
    (defTop
        { t_name     = "topTester"
        , t_inputs   = []
        , t_outputs  = ["LEDG"]
        , t_extraIn  = [ ("CLOCK_50", 1)
                       , ("KEY0"    , 1)
                       ]
        , t_clocks   = [ (altpll "altpll50"
                                 "CLOCK_50(0)"
                                 "not KEY0(0)")
                       ]
        }) #-}
topEntity :: Signal P -> Signal Bool
topEntity = topTester

testInput      =
    stimuliGenerator $(v [(1,1)::(Unsigned 10, Unsigned 10),(2,2)])
expectedOutput = outputVerifier $(v ([False, False]::[Bool]))


--mealy :: (s -> i -> (s,o))
--    -> s
--    -> (Signal i -> Signal o)
--asyncRam :: Enum addr => SNat newtype ->  Signal addr -> Signal addr -> Signal Bool -> Signal a -> Sig  nal ap
--
-}

tMemory :: Signal (Unsigned 4) -> Signal (Unsigned 4) -> Signal Bool -> Signal C -> Signal C
tMemory = asyncRam d10


