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
import Control.Arrow


type C = Unsigned 10
type P = (C, C)
type T = (P, P, P)

p0 = (0, 0) :: P

smminus :: Signal C -> Signal C -> Signal (Signed 12)
smminus a b = mminus <$> a <*> b

mminus :: Unsigned 10 -> Unsigned 10 -> Signed 12
mminus a b = uts a `minus` uts b
  where
    uts :: Unsigned 10 -> Signed 11
    uts n = resize . bitCoerce $ n


mminusS a b = mminus <$> a <*> b


test1 :: Signal (Unsigned 8) -> Signal (Unsigned 8)
test1 a = register 0 $ a + 1

data S = P1 | P2 | P3 | R

stage0T (p, p1, p2, p3, st) (rst, re, p')
  | rst       = (p, p1, p2, p3, P1)
  | otherwise = case st of
                  P1 -> (p, p', p2, p3, P2)
                  P2 -> (p, p1, p', p3, P3)
                  P3 -> (p, p1, p2, p', R )
                  R  -> if re
                           then (p', p1, p2, p3, R )
                           else (p , p2, p3, p1, R )

stage0out (p, p1, p2, p3, _) = (p, p1, p2 ,p3)

stage0adap s =
  (\(a, b, c, d) -> (unbundle a, unbundle b, unbundle c, unbundle d)) $ unbundle s


stage0 = moore stage0T stage0out (p0, p0, p0, p0, P1)

stage1 ( (px, py)
       , (p1x, p1y)
       , (p2x, p2y)
       , (p3x, p3y) ) = ((t1, t2), (t3, t4))
  where
    t1 = register 0 $ px  `smminus` p3x
    t2 = register 0 $ p2y `smminus` p3y
    t3 = register 0 $ p2x `smminus` p3x
    t4 = register 0 $ px  `smminus` p3x

stage2_1 (t1, t2) = register 0 $ t1 `times` t2

stage2 = stage2_1 *** stage2_1

stage3 (m1, m2) = register False $ m1 .<. m2

stage4 a = register False a


-- sign = stage0 >>> stage1 >>> stage2 >>> stage3 >>> stage4
sign = stage0 >>> stage0adap >>> stage1 >>> stage2 >>> stage3 >>> stage4
