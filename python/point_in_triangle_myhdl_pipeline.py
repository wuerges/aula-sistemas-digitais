
from myhdl import *
import random as r
import point_in_triangle as pt

r.seed(5)

t_state = enum('P1_input', 'P2_input', 'P3_input', 'RUN')


@block
def sign(clk, rst, out, re, i1, i2):

    state = Signal(t_state.P1_input)

    ptx, p1x, p2x, p3x = [Signal(intbv(0)) for i in range(4)]
    pty, p1y, p2y, p3y = [Signal(intbv(0)) for i in range(4)]

    m1, m2, t1, t2, t3, t4 = [Signal(intbv(0)) for i in range(6)]

    @always_seq(clk.posedge, reset=rst)
    def logic():
        print("SIGN", ptx, pty, p1x, p1y, p2x, p2y, p3x, p3y, m1, m2, t1, t2, t3, t4, out, state)
        if(rst == 0):
            state.next = t_state.P1_input
            out.next = 0
        else:
            if state == t_state.P1_input:
                state.next = t_state.P2_input
                p1x.next = i1
                p1y.next = i2

            if state == t_state.P2_input:
                state.next = t_state.P3_input
                p2x.next = i1
                p2y.next = i2

            if state == t_state.P3_input:
                state.next = t_state.RUN
                p3x.next = i1
                p3y.next = i2

            if state == t_state.RUN:
                if (re == 0):
                    ptx.next = i1
                    pty.next = i2

                p1x.next = p2x
                p1y.next = p2y

                p2x.next = p3x
                p2y.next = p3y

                p3x.next = p1x
                p3y.next = p1y

                t1.next = ptx - p3x
                t2.next = p2y - p3y
                t3.next = p2x - p3x
                t4.next = pty - p3y

                m1.next = t1 * t2
                m2.next = t3 * t4

                out.next =  m1 < m2

    return logic

@block
def test_sign():
    out = Signal(bool(0)) 

    px = Signal(intbv(0, 0, 800))
    py = Signal(intbv(0, 0, 600))

    rst = ResetSignal(1, active=0, async=True)
    clk = Signal(bool(0))
    re  = Signal(bool(0))

    @always(delay(10))
    def clkgen():
        clk.next = not clk

    sign_1 = sign(clk, rst, out, re, px, py)

    @instance
    def stimulus():
        print("testing sign")
        for i in range(1):
            #p, p1, p2, p3 = [ pt.P(r.randint(0, 800-1) \
            #                ,      r.randint(0, 600-1)) for i in range(4)]

            p  = pt.P(2, 10)
            p1 = pt.P(1, 1)
            p2 = pt.P(20, 1)
            p3 = pt.P(10, 10)
            #print(pt.sign(p, p1, p2) < 0)
            #print(pt.sign(p, p2, p3) < 0)
            #print(pt.sign(p, p3, p1) < 0)

            px.next = p1.x
            py.next = p1.y
            yield clk.posedge

            px.next = p2.x
            py.next = p2.y
            yield clk.posedge

            px.next = p3.x
            py.next = p3.y
            yield clk.posedge

            px.next = p.x
            py.next = p.y
            re.next = 0

            yield clk.posedge
            re.next = 1

            yield clk.posedge

            yield clk.posedge
            yield clk.posedge
            yield clk.posedge
            yield clk.posedge
            yield clk.posedge
            yield clk.posedge
            yield clk.posedge
            yield clk.posedge
            yield clk.posedge
            yield clk.posedge
            yield clk.posedge
            yield clk.posedge

            exit(0)
#            yield delay(10)
#            print("out", out)
#
#            yield delay(10)
#            print("out", out)
#
#            yield delay(10)
#            print("out", out)
#
#            yield delay(10)
#            print("out", out)
#
#            yield delay(10)
#            print("out", out)
#
#            yield delay(10)
#            print("out", out)
#
#            yield delay(10)
#            print("out", out)
#
#            yield delay(10)
#            print("out", out)
#

            #if(out != (pt.sign(p1, p2, p3) < 0)):
            #    raise ValueError("Signal missmatch")

    return sign_1, stimulus, clkgen

tb = test_sign()
tb.run_sim()


