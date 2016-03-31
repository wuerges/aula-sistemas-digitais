{-# LANGUAGE RecordWildCards #-}
module TrianglePipeline where

import CLaSH.Prelude
import CLaSH.Sized.Vector

type C = Unsigned 10
type P = (C, C)
type T = (P, P, P)


--def sign(p1, p2, p3):
--    return (p1.x - p3.x) * (p2.y - p3.y) -
--           (p2.x - p3.x) * (p1.y - p3.y);


rotateT :: T -> T
rotateT (p1, p2, p3) = (p2, p3, p1)

data S = P1 | P2 | P3 | R

data ST = ST { tr :: T
             , t1 :: Signed 12
             , t2 :: Signed 12
             , t3 :: Signed 12
             , t4 :: Signed 12
             , m1 :: Signed 24
             , m2 :: Signed 24
             , r  :: Bool
             , state :: S
             }
initialST = ST { tr = ((0, 0), (0, 0), (0, 0))
               , t1 = 0
               , t2 = 0
               , t3 = 0
               , t4 = 0
               , m1 = 0
               , m2 = 0
               , r = False
               , state = P1
               }

data I = I P | IRst


uts :: Unsigned 10 -> Signed 11
uts n = resize . bitCoerce $ n

mminus a b = uts a `minus` uts b

signT :: ST -> I -> (ST, Bool)
--signT = undefined

--def sign(p1, p2, p3):
--    return (p1.x - p3.x) * (p2.y - p3.y) -
--           (p2.x - p3.x) * (p1.y - p3.y);

signT (s@ST{..}) IRst    = (s { state = P1 }, False)
signT (s@ST{..}) (I ipt) =
    case state of
      P1 -> (s { state = P2, tr = (ipt,  p2,  p3) }, False)
      P2 -> (s { state = P3, tr = ( p1, ipt,  p3) }, False)
      P3 -> (s { state = R,  tr = ( p1,  p2, ipt) }, False)
      R -> (s { tr = rotateT tr
              , t1 = ptx `mminus` p3x
              , t2 = p2y `mminus` p3y
              , t3 = p2x `mminus` p3x
              , t4 = pty `mminus` p3y
              , m1 = t1 `times` t2
              , m2 = t3 `times` t4
              , r  = m1 < m2 }, r)

  where
    (p1@(p1x, p1y), p2@(p2x,p2y), p3@(p3x,p3y)) = tr
    (ptx, pty)                                  = ipt






sign      = mealy signT initialST
topEntity = sign

testInput      = stimuliGenerator ti1
expectedOutput = outputVerifier eti1

ti1 =
  IRst :> I (10,10)    :> I (200, 100) :> I (300, 300)
       :> I (178, 168)
       :> I (178, 168)
       :> I (178, 168)
       :> I (178, 168)
       :> I (178, 168)
       :> I (178, 168)
       :> Nil

eti1 =
  False :> Nil

ti2 =
  IRst :> I (10, 10) :> I (200, 100) :> I (300, 300)
       :> I (795, 22)
       :> I (795, 22)
       :> I (795, 22)
       :> I (795, 22)
       :> I (795, 22)
       :> I (795, 22)
       :> Nil

eti2 =
  False :> False :> False :>
  False :> False :> False :>
  False :> False :> True :>
  False :> False :> True :>
  Nil






