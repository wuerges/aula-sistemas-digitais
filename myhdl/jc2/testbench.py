from myhdl import *

ACTIVE, INACTIVE = bool(0), bool(1)

from johnson import jc2

@block
def test(jc2):

    goLeft, goRight, stop, clk = [Signal(INACTIVE) for i in range(4)]
    q = Signal(intbv(0)[4:])

    @always(delay(10))
    def clkgen():
        clk.next = not clk

    jc2_inst = jc2(goLeft, goRight, stop, clk, q)

    @instance
    def stimulus():
        for i in range(3):
            yield clk.negedge
        for sig, nrcycles in ((goLeft, 10), (stop, 3), (goRight, 10)):
            sig.next = ACTIVE
            yield clk.negedge
            sig.next = INACTIVE
            for i in range(nrcycles-1):
                yield clk.negedge
        raise StopSimulation

    @instance
    def monitor():
        print("goLeft goRight stop clk q")
        print("-------------------------")
        while True:
            yield clk.negedge
            yield delay(1)
            print("%d %d %d" % (goLeft, goRight, stop),end=' ')
            yield clk.posedge
            print("C",end=' ')
            yield delay(1)
            print(bin(q, 4))

    return clkgen, jc2_inst, stimulus, monitor

sim = test(jc2)
sim.config_sim(trace=True)
sim.run_sim()

