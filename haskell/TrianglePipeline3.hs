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
     , m2 :: Signed 24



data D = D { point    :: P
           , p1 :: P
           , p2 :: P
           , p3 :: P
           , t1 :: Signed 12
           , t2 :: Signed 12
           , t3 :: Signed 12
           , t4 :: Signed 12
           , m1 :: Signed 24
           , m2 :: Signed 24 }

initD = D { point = (0, 0)
          , p1    = (0, 0)
          , p2    = (0, 0)
          , p3    = (0, 0)
          , t1    = 0
          , t2    = 0
          , t3    = 0
          , t4    = 0
          , m1    = 0
          , m2    = 0 }

uts :: Unsigned 10 -> Signed 11
uts n = resize . bitCoerce $ n
mminus a b = uts a `minus` uts b

signT :: (S, D) -> (Bool, Bool, P) -> ((S, D), Bool)
signT (st, dat) (readP, readT, p) =
  case st of
    P1 -> ((nexts P1, dat { p1    = p }), False)
    P2 -> ((nexts P3, dat { p2    = p }), False)
    P3 -> ((nexts R , dat { p3    = p }), False)
    R  -> ((nexts R , dat'             ), r    )

  where
    dat' = dat { point = point'
               , p1 = p2 dat
               , p2 = p3 dat
               , p3 = p1 dat
               , t1 = fst (point dat) `mminus` fst (p3 dat)
               , t2 = snd (   p2 dat) `mminus` snd (p3 dat)
               , t3 = fst (   p2 dat) `mminus` fst (p3 dat)
               , t4 = snd (point dat) `mminus` snd (p3 dat)
               , m1 = t1 dat `times` t2 dat
               , m2 = t3 dat `times` t4 dat
               }
    nexts s
      | readT     = P1
      | otherwise = s

    point'
      | readP     = p
      | otherwise = point dat

    r = m1 dat < m2 dat

topEntity = mealy signT (P1, initD)


