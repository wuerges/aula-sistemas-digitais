module TrianglePipeline2 where

import CLaSH.Prelude
import CLaSH.Sized.Vector

type C = Unsigned 10
type P = (C, C)
type T = (P, P, P)


rotateT :: T -> T
rotateT (p1, p2, p3) = (p2, p3, p1)

--data S = P1 | P2 | P3 | R
--data I = I P | IRst

uts :: Unsigned 10 -> Signed 11
uts n = resize . bitCoerce $ n

mminus a b = uts a `minus` uts b

sign :: Signal (P, Bool) -> Signal Bool
sign inp = o
    where
        (ipt, rst) = unbundle inp
        (ptx, pty) = unbundle ipt

        state = register (0 :: Unsigned 2) $
            case state of
              0 -> 1
              1 -> 2
              2 -> 3
              3 -> 3

        tr = register ((0,0), (0,0), (0,0)) $
                case state of
                  0 -> bundle (ipt, p2 , p3 )
                  1 -> bundle (p1 , ipt, p3 )
                  2 -> bundle (p1 , p2 , ipt)
                  3 -> rotateT <$> tr

        (p1, p2, p3) = unbundle tr
        (p1x, p1y) = unbundle p1
        (p2x, p2y) = unbundle p2
        (p3x, p3y) = unbundle p3


        mminus' a b = mminus <$> a <*> b

        t1 = ptx `mminus'` p3x
        t2 = p2y `mminus'` p3y
        t3 = p2x `mminus'` p3x
        t4 = pty `mminus'` p3y

        m1 = r_t1 `times` r_t2
        m2 = r_t3 `times` r_t4

        r_t1 = register 0 t1
        r_t2 = register 0 t2
        r_t3 = register 0 t3
        r_t4 = register 0 t4

        r_m1 = register 0 m1
        r_m2 = register 0 m2

        o = register False $ r_m1 .<. r_m2


topEntity = sign
