module Triangle where

import CLaSH.Prelude
import TriangleTypes

uts :: Unsigned 10 -> Signed 11
uts n = resize . bitCoerce $ n

{-

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

--tMemory :: Signal (Unsigned 4) -> Signal (Unsigned 4) -> Signal Bool -> Signal C -> Signal C
--tMemory = asyncRam d10


type Addr = Unsigned 4
type TMemST = (Vec 12 C, Addr, Addr)

tMemoryT :: TMemST -> (Bool, Bool, C, Bool) -> (TMemST, C)
tMemoryT (m, c_write, c_read) (rst, we, dat, re) | rst       = ((m, 0, 0),               rv)
                                                 | otherwise = ((m', c_write', c_read'), rv)
    where m' = if we then replace c_write dat m
                     else m
          c_write' = if we then c_write + 1
                           else c_write
          c_read' = if re then c_read + 1
                          else c_read
          rv = m !! c_read


tMemory :: Signal (Bool, Bool, C, Bool) -> Signal C
tMemory = mealy tMemoryT (replicate d12 0, 0, 0)


{-
sign p1 p2 p3 = s1 .<. s2
    where
        s1 =         (uts (fst up1) `minus` uts (fst up3))
             `times` (uts (snd up2) `minus` uts (snd up3))
        s2 =         (uts (fst up2) `minus` uts (fst up3))
             `times` (uts (snd up1) `minus` uts (snd up3))

        up1 = unbundle p1
        up2 = unbundle p2
        up3 = unbundle p3
-}

type Ext11 = Signed 12
type Ext22 = Signed 24
type PAddr = Unsigned 3
type PST = (C, Vec 4 Ext11, Vec 2 Ext22, Unsigned 10)

-- | Ordering of coordinates must be: [p1x, p3x, p2y, p3y, p2x, p3x, p1y, p3y]
psignT :: PST -> (Bool, C) -> (PST, Bool)
psignT (aux, vms, vss, state) (rst, c)
  | rst       = ((0, vms, vss, 0), False)
  | otherwise = ((aux', vms', vss', state'), o)
      where
        aux' = c
        vms' = case state of
                 1 -> replace 0 (uts aux `minus` uts c) vms
                 3 -> replace 1 (uts aux `minus` uts c) vms
                 5 -> replace 2 (uts aux `minus` uts c) vms
                 7 -> replace 3 (uts aux `minus` uts c) vms
                 _ -> vms
        vss' = case state of
                 4 -> replace 0 ((vms !! 0) `times` (vms !! 1)) vss
                 8 -> replace 1 ((vms !! 2) `times` (vms !! 3)) vss
                 _ -> vss
        state' = case state of
                  9 -> 0
                  _  -> state + 1
        o = (vss !! 0) < (vss !! 1)

psign :: Signal (Bool, C) -> Signal Bool
psign = mealy psignT (replicate d6 0, replicate d4 0, replicate d2 0, 0)

 {-insideT :: Signal T -> Signal P -> Signal Bool
insideT t pt =
        sign pt v1 v2 .&&. sign pt v2 v3 .&&. sign pt v3 v1
    where (v1, v2, v3) = unbundle t
  -}

type TST = (Vec 6 C, Unsigned 10)
ptriangleT :: TST -> (Bool, C) -> (TST, (Bool,C))
ptriangleT (m, state) (rst, c)
  | rst       = ((m, 0),       (rst, c))
  | otherwise = ((m', state'), (rst', o))
      where
        m' = case state of
               0 -> replace state c m
               1 -> replace state c m
               2 -> replace state c m
               3 -> replace state c m
               4 -> replace state c m
               5 -> replace state c m
               _ -> m
        state' = case state of
                   50 -> 0
                   _ -> state + 1



topEntity      = psign
testInput      =
  stimuliGenerator $(v [(True, 0):: (Bool, C), (False, 200), (False, 200), (False, 200), (False, 200), (False, 200), (False, 200), (False, 200), (False, 200), (False, 200), (False, 200), (False, 200), (False, 200) ])


expectedOutput = outputVerifier $(v [False, False, False, False, False, False, False, False, False, False, False, False, False, False, False])


