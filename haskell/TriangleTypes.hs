module TriangleTypes where

import CLaSH.Prelude

type P = (Unsigned 10, Unsigned 10)
type T = (P, P, P)

t1 = ((10, 10), (200,100), (300, 300))   :: T
t2 = ((400, 400), (700,400), (700, 600)) :: T

triangulos = [t1, t2]
