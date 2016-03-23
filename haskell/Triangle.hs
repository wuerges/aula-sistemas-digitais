module Triangle where

import CLaSH.Prelude
import TriangleTypes

uts :: Unsigned 10 -> Signed 11
uts n = resize . bitCoerce $ n

type Addr = Unsigned 4
type TMemST = (Vec 12 C, Addr, Addr)

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
                 0 -> replace 1 ((vms !! 2) `times` (vms !! 3)) vss
                 _ -> vss
        state' = case state of
                  7 -> 0
                  _  -> state + 1
        o = (vss !! 0) < (vss !! 1)

psign :: Signal (Bool, C) -> Signal Bool
psign = mealy psignT (0, replicate d4 0, replicate d2 0, 0)

{-insideT :: Signal T -> Signal P -> Signal Bool
insideT t pt =
       sign pt v1 v2 .&&. sign pt v2 v3 .&&. sign pt v3 v1
    where (v1, v2, v3) = unbundle t
 -}
-- | Ordering of coordinates must be: [p1x, p3x, p2y, p3y, p2x, p1y]
-- | Ordering of coordinates must be: [p1x, p3x, p2y, p3y, p2x, p3x, p1y, p3y]
type TST = (C, C, C, C, C, C, C, C, Unsigned 10)
ptriangleT :: TST -> (Bool, C) -> (TST, (Bool,C, Bool))
ptriangleT (ptx, pty, p1x, p1y, p2x, p2y, p3x, p3y, state) (rst, c)
  | rst       = ((0, 0, 0, 0, 0, 0, 0, 0, 0),       (rst, c, False))
  | otherwise = ((ptx', pty', p1x', p1y', p2x', p2y', p3x', p3y', state'), (rst', o, res))
      where
        ptx' | state == 0 = c
             | otherwise = ptx

        pty' | state == 1 = c
             | otherwise = pty

        p1x' | state == 2 = c
             | otherwise = p1x

        p1y' | state == 3 = c
             | otherwise = p1y

        p2x' | state == 4 = c
             | otherwise = p2x

        p2y' | state == 5 = c
             | otherwise = p2y

        p3x' | state == 6 = c
             | otherwise = p3x

        p3y' | state == 7 = c
             | otherwise = p3y

        o = case state of
              -- first round: pt <= p1, v1 <= p2, v2 <= p3
              4  -> ptx -- p1x
              5  -> p2x -- p3x
              6  -> p1y -- p2y
              7  -> p2y -- p3y
              8  -> p1x -- p2x
              9  -> p2x -- p3x
              10 -> pty -- p1y
              11 -> p2y -- p3y
              -- second round: pt <= p1, v2 <= p2, v3 <= p3
              12 -> ptx -- p1x
              13 -> p3x -- p3x -- result1
              14 -> p2y -- p2y
              15 -> p3y -- p3y
              16 -> p2x -- p2x
              17 -> p3x -- p3x
              18 -> pty -- p1y
              19 -> p3y -- p3y
              -- first round: pt <= p1, v3 <= p2, v1 <= p3
              20 -> ptx -- p1x
              21 -> p1x -- p3x -- result2
              22 -> p3y -- p2y
              23 -> p1y -- p3y
              24 -> p3x -- p2x
              25 -> p1x -- p3x
              26 -> pty -- p1y
              27 -> p1y -- p3y
              _  -> 0

        rst' = state == 3
        res = case state of
                 1  -> True
                 13 -> True
                 21 -> True
                 _  -> False
        state' = case state of
                   27 -> 0
                   _ -> state + 1


ptriangle :: Signal (Bool, C) -> Signal (Bool, C, Bool)
ptriangle = mealy ptriangleT (0, 0, 0, 0, 0, 0, 0, 0, 0)

--psign :: Signal (Bool, C) -> Signal Bool

outputCheckT :: (Unsigned 2, Bool, Bool, Bool) -> (Bool, Bool) -> ((Unsigned 2, Bool, Bool, Bool), (Bool, Bool))
outputCheckT (s, r1, r2, r3) (v, r) = ((s', r1', r2', r3'), (v', r'))
  where
    v' = s == 3
    r' = (r1 == r2) && (r2 == r3) && v'

    s' | v && (s == 3) = 1
       | v           = s + 1
       | otherwise   = s

    r1' | s == 1 = r
        | otherwise = r1

    r2' | s == 2 = r
        | otherwise = r2

    r3' | s == 3 = r
        | otherwise = r3


poutputCheck :: Signal (Bool, Bool) -> Signal (Bool, Bool)
poutputCheck = mealy outputCheckT (0, False, False, False)


completeMachine :: Signal (Bool, C) -> Signal (Bool, Bool)
completeMachine s = poutputCheck (bundle (valid, result))
  where
    (rst, c, valid) = unbundle $ ptriangle s
    result = psign (bundle (rst, c))


topEntity      = completeMachine

testInput      =
  stimuliGenerator $(v [ (True, 0):: (Bool, C)
                       , (False, 200)
                       ])

expectedOutput = outputVerifier $(v [ (False, False)
                                    , (False, False)
                                    , (False, False)
                                    , (False, False)
                                    , (False, False)
                                    , (False, False)
                                    , (False, False)
                                    , (False, False)
                                    , (False, False)
                                    , (False, False)
                                    , (False, False)
                                    , (False, False)
                                    , (False, False)
                                    , (False, False)
                                    , (False, False)
                                    , (False, False)
                                    , (False, False)
                                    , (False, False)
                                    , (False, False)
                                    , (False, False)
                                    , (False, False)
                                    , (False, False)
                                    , (False, False)
                                    , (True, True)
                                    , (True, True)
                                    , (True, True)
                                    , (True, True)
                                    , (True, True)
                                    , (True, True)
                                    , (True, True)
                                    , (True, True)
                                    , (False, False)
                                    ])


testInputTriangle =
  stimuliGenerator $(v [ (True, 0):: (Bool, C)
                       , (False, 200) ])
expectedOutputTriangle = outputVerifier $(v [ (True, 0, False)::(Bool, C, Bool)  -- global reset                                    --  0
                                            , (False, 0, False)                  -- ptriangle state = 0                             --  1
                                            , (False, 0, True)                   -- first valid output                              --  2
                                            , (False, 0, False)                  -- idle                                            --  3
                                            , (True,  0, False)                  -- reset psign                                     --  4
                                            , (False, 200, False)                -- psign starts receiving inputs psign state = 0   --  5
                                            , (False, 200, False)                                                                   --  6
                                            , (False, 200, False)                                                                   --  7
                                            , (False, 200, False)                                                                   --  8
                                            , (False, 200, False)                                                                   --  9
                                            , (False, 200, False)                                                                   -- 10
                                            , (False, 200, False)                                                                   -- 11
                                            , (False, 200, False)                                                                   -- 12
                                            , (False, 200, False)                                                                   -- 13
                                            , (False, 200, True)         -- first sign output                                       -- 14
                                            , (False, 200, False)                                                                   -- 15
                                            , (False, 200, False)                                                                   -- 16
                                            , (False, 200, False)                                                                   -- 17
                                            , (False, 200, False)                                                                   -- 18
                                            , (False, 200, False)                                                                   -- 19
                                            , (False, 200, False)                                                                   -- 20
                                            , (False, 200, False)                                                                   -- 21
                                            , (False, 200, True)         -- second sign output                                      -- 22
                                            , (False, 200, False)                                                                   -- 23
                                            , (False, 200, False)                                                                   -- 24
                                            , (False, 200, False)                                                                   -- 25
                                            , (False, 200, False)                                                                   -- 26
                                            , (False, 200, False)                                                                   -- 27
                                            , (False, 200, False)                                                                   --  0
                                            , (False, 0, False)                                                                     --  1
                                            , (False, 0, True)                   -- first valid output                              --  2 -- start second cycle
                                            , (False, 0, False)                  -- idle                                            --  3
                                            , (True,  0, False)                  -- reset psign                                     --  4
                                            , (False, 200, False)                -- psign starts receiving inputs psign state = 0   --  5
                                            , (False, 200, False)                                                                   --  6
                                            , (False, 200, False)                                                                   --  7
                                            , (False, 200, False)                                                                   --  8
                                            , (False, 200, False)                                                                   --  9
                                            , (False, 200, False)                                                                   -- 10
                                            , (False, 200, False)                                                                   -- 11
                                            , (False, 200, False)                                                                   -- 12
                                            , (False, 200, False)                                                                   -- 13
                                            , (False, 200, True)         -- first sign output                                       -- 14
                                            , (False, 200, False)                                                                   -- 15
                                            , (False, 200, False)                                                                   -- 16
                                            , (False, 200, False)                                                                   -- 17
                                            , (False, 200, False)                                                                   -- 18
                                            , (False, 200, False)                                                                   -- 19
                                            , (False, 200, False)                                                                   -- 20
                                            , (False, 200, False)                                                                   -- 21
                                            , (False, 200, True)         -- second sign output                                      -- 22
                                            , (False, 200, False)                                                                   -- 23
                                            , (False, 200, False)                                                                   -- 24
                                            , (False, 200, False)                                                                   -- 25
                                            , (False, 200, False)                                                                   -- 26
                                            , (False, 200, False)                                                                   -- 27
                                            , (False, 200, False)                                                                   -- 28
                                            , (False, 0, False)                                                                     -- 29
                                            ])


