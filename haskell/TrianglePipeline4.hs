module TP3 where

import CLaSH.Prelude
import CLaSH.Sized.Vector

type C = Unsigned 10
type P = (C, C)
type T = (P, P, P)

rotateT :: T -> T
rotateT (p1, p2, p3) = (p2, p3, p1)

data S = P1 | P2 | P3 | R

data Stage1 =
  S1 { point :: P
     , p1 :: P
     , p2 :: P
     , p3 :: P }

data Stage2 =
  S2 { t1 :: Signed 12
     , t2 :: Signed 12
     , t3 :: Signed 12
     , t4 :: Signed 12 }

data Stage3 =
  S3 { m1 :: Signed 24
     , m2 :: Signed 24 }

data Stage4 =
  S4 { r :: Bool }

uts :: Unsigned 10 -> Signed 11
uts n = resize . bitCoerce $ n
mminus a b = uts a `minus` uts b

stage1T :: ((Stage1, S) -> (Bool, Bool, P) -> (Stage1, S))
stage1T (s1, st) (rst, re, p)
  | rst       = (s1, P1)
  | otherwise =
    case st of
      P1 -> (s1 { p1 = p }, P2)
      P2 -> (s1 { p2 = p }, P3)
      P3 -> (s1 { p3 = p }, R )
      R  -> if re
               then (s1 { point = p }, R)
               else (s1              , R)

stage1 :: Signal (Bool, Bool, P) -> Signal Stage1
stage1 = moore stage1T fst (S1 (0, 0) (0, 0) (0, 0) (0, 0), P1)

stage2T :: Stage2 -> Stage1 -> Stage2
stage2T _ (S1 p p1 p2 p3) = S2 t1 t2 t3 t4
  where
    t1 = fst p  `mminus` fst p3
    t2 = snd p2 `mminus` snd p3
    t3 = fst p2 `mminus` fst p3
    t4 = snd p  `mminus` snd p3

stage2 :: Signal Stage1 -> Signal Stage2
stage2 = moore stage2T id $ S2 0 0 0 0

stage3T :: Stage3 -> Stage2 -> Stage3
stage3T _ (S2 t1 t2 t3 t4) = S3 m1 m2
  where
    m1 = t1 `times` t2
    m2 = t3 `times` t4


stage3 :: Signal Stage2 -> Signal Stage3
stage3 = moore stage3T id $ S3 0 0

stage4T :: Stage4 -> Stage3 -> Stage4
stage4T _ (S3 m1 m2) = S4 $ m1 < m2

stage4 :: Signal Stage3 -> Signal Bool
stage4 = moore stage4T r $ S4 False

sign ::Signal (Bool, Bool, P) -> Signal Bool
sign = stage4 . stage3 . stage2 . stage1


topEntity = sign
