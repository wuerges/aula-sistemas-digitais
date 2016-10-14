

from myhdl import *
import random as r
import point_in_triangle as pt

r.seed(5)


@block
def sign(out, p1x, p1y, p2x, p2y, p3x, p3y):

    @always_comb
    def logic():
        out.next = (p1x - p3x) * (p2y - p3y) < (p2x - p3x) * (p1y - p3y)

    return logic

@block
def test_sign():
    out = Signal(bool(0)) 
    p1x, p2x, p3x = [Signal(intbv(0, 0, 800)) for i in range(3)]
    p1y, p2y, p3y = [Signal(intbv(0, 0, 600)) for i in range(3)]

    sign_1 = sign(out, p1x, p1y, p2x, p2y, p3x, p3y)

    @instance
    def stimulus():
        print("testing sign")
        for i in range(10):
            p1, p2, p3 = [ pt.P(r.randint(0, 800-1) \
                         ,      r.randint(0, 600-1)) for i in range(3)]
            p1x.next = p1.x
            p1y.next = p1.y
            p2x.next = p2.x
            p2y.next = p2.y
            p3x.next = p3.x
            p3y.next = p3.y
            yield delay(10)

            if(out != (pt.sign(p1, p2, p3) < 0)):
                raise ValueError("Signal missmatch")

    return sign_1, stimulus

tb = test_sign()
tb.run_sim()

