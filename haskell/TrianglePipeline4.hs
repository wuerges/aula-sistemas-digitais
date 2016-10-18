{-|
  Module      : TP4
  Description : Checks if a point is inside a triangle
  Copyright   : (c) Emilio Wuerges, 2016
  License     : BSD-3
  Maintainer  : wuerges@gmail.com
  Stability   : experimental
  Portability : POSIX

This module implements a circuit for checking if a
point is inside a triangle.

The circuit works using a pipeline with 4 stages.
'Stage1', 'Stage2', 'Stage3' and 'Stage4'.
-}

module TP4 where

import CLaSH.Prelude
import CLaSH.Sized.Vector
import Control.Arrow

type C = Unsigned 10
type P = (C, C)
type T = (P, P, P)

-- | The structure 'S' represents the possible states
-- 'P1': input of point 1
-- 'P2': input of point 2
-- 'P3': input of point 3
-- 'R' : performs the calculations
data S = P1 | P2 | P3 | R

-- | The structure 'Stage1' represents the data used
-- in the first stage of the pipeline
data Stage1 =
  S1 { point :: P
     , p1 :: P
     , p2 :: P
     , p3 :: P }

-- | The function 'rotateStage' rotates the
-- points 'p1', 'p2' and 'p3'.
rotateStage (S1 p p1 p2 p3) = S1 p p2 p3 p1


-- | The structure 'Stage2' represents the data used
-- in the second stage of the pipeline
data Stage2 =
  S2 { t1 :: Signed 12
     , t2 :: Signed 12
     , t3 :: Signed 12
     , t4 :: Signed 12 }


-- | The structure 'Stage3' represents the data used
-- in the third stage of the pipeline
data Stage3 =
  S3 { m1 :: Signed 24
     , m2 :: Signed 24 }


-- | The structure 'Stage4' represents the data used
-- in the fourth stage of the pipeline
data Stage4 =
  S4 { r :: Bool }

-- | The function 'mminus' performs a subtraction,
-- but before it converts the input to a signed value
-- and returns the signed result.
mminus :: Unsigned 10 -> Unsigned 10 -> Signed 12
mminus a b = uts a `minus` uts b
  where
    uts :: Unsigned 10 -> Signed 11
    uts n = resize . bitCoerce $ n

-- | The function 'stage1T' performs the state transition
-- for the first stage of the pipeline
stage1T :: ((Stage1, S) -> (Bool, Bool, P) -> (Stage1, S))
stage1T (s1, st) (rst, re, p)
  | rst       = (s1, P1)
  | otherwise =
    case st of
      P1 -> (s1 { p1 = p }, P2)
      P2 -> (s1 { p2 = p }, P3)
      P3 -> (s1 { p3 = p }, R )
      R  -> if re
               then (s1 { point = p  }, R)
               else (rotateStage s1   , R)

-- | The function 'stage2T' performs the state transition
-- for the second stage of the pipeline
stage2T :: Stage2 -> Stage1 -> Stage2
stage2T _ (S1 p p1 p2 p3) = S2 t1 t2 t3 t4
  where
    t1 = fst p  `mminus` fst p3
    t2 = snd p2 `mminus` snd p3
    t3 = fst p2 `mminus` fst p3
    t4 = snd p  `mminus` snd p3

-- | The function 'stage3T' performs the state transition
-- for the third stage of the pipeline
stage3T :: Stage3 -> Stage2 -> Stage3
stage3T _ (S2 t1 t2 t3 t4) = S3 m1 m2
  where
    m1 = t1 `times` t2
    m2 = t3 `times` t4


-- | The function 'stage4T' performs the state transition
-- for the fourth stage of the pipeline
stage4T :: Stage4 -> Stage3 -> Stage4
stage4T _ (S3 m1 m2) = S4 $ m1 < m2

-- | The function 'stage1' is the moore machine of the first stage
stage1 :: Signal (Bool, Bool, P) -> Signal Stage1
stage1 = moore stage1T fst (S1 (0, 0) (0, 0) (0, 0) (0, 0), P1)

-- | The function 'stage2' is the moore machine of the second stage
stage2 :: Signal Stage1 -> Signal Stage2
stage2 = moore stage2T id $ S2 0 0 0 0

-- | The function 'stage3' is the moore machine of the third stage
stage3 :: Signal Stage2 -> Signal Stage3
stage3 = moore stage3T id $ S3 0 0

-- | The function 'stage4' is the moore machine of the fourth stage
stage4 :: Signal Stage3 -> Signal Bool
stage4 = moore stage4T r $ S4 False

-- | The function 'sign' is the moore machine composed
-- of the moore machines of each stage.
sign ::Signal (Bool, Bool, P) -> Signal Bool
sign = stage1 >>> stage2 >>> stage3 >>> stage4


topEntity = sign
