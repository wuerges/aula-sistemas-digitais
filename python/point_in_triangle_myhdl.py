from myhdl import *
import random as r
import point_in_triangle as pt

r.seed(5)


def sign(out, p1x, p1y, p2x, p2y, p3x, p3y):

    @always_comb
    def logic():
        out.next = (p1x - p3x) * (p2y - p3y) < (p2x - p3x) * (p1y - p3y)

    return logic

def insideT(out, ptx, pty, p1x, p1y, p2x, p2y, p3x, p3y):

    s1 = Signal(bool(0))
    s2 = Signal(bool(0))
    s3 = Signal(bool(0))

    sign1 = sign(s1, ptx, pty, p1x, p1y, p2x, p2y)
    sign2 = sign(s2, ptx, pty, p2x, p2y, p3x, p3y)
    sign3 = sign(s3, ptx, pty, p3x, p3y, p1x, p1y)

    @always_comb
    def logic():

        out.next = (s1 == s2) & (s2 == s3)

    return sign1, sign2, sign3, logic


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
        print("finished simulation")

    return sign_1, stimulus

tb = test_sign()
sim = Simulation(tb)
sim.run()

out = Signal(bool(0)) 
ptx, p1x, p2x, p3x = [Signal(intbv(0, 0, 800)) for i in range(4)]
pty, p1y, p2y, p3y = [Signal(intbv(0, 0, 600)) for i in range(4)]
#t = insideT(out, ptx, pty, p1x, p1y, p2x, p2y, p3x, p3y)

ver = toVerilog(insideT, out, ptx, pty, p1x, p1y, p2x, p2y, p3x, p3y)
