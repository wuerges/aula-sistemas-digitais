from myhdl import *

ACTIVE = 0
DirType = enum('RIGHT', 'LEFT')

@block
def jc2(goLeft, goRight, stop, clk, q):

    """ A bi-directional 4-bit Johnson counter with stop control.

    I/O pins:
    --------
    clk      : input free-running slow clock
    goLeft   : input signal to shift left (active-low switch)
    goRight    : input signal to shift right (active-low switch)
    stop     : input signal to stop counting (active-low switch)
    q        : 4-bit counter output (active-low LEDs; q[0] is right-most)

    """

    dir = Signal(DirType.LEFT)
    run = Signal(False)

    @always(clk.posedge)
    def logic():
        # direction
        if goRight == ACTIVE:
            dir.next = DirType.RIGHT
            run.next = True
        elif goLeft == ACTIVE:
            dir.next = DirType.LEFT
            run.next = True
        # stop
        if stop == ACTIVE:
            run.next = False
        # counter action
        if run:
            if dir == DirType.LEFT:
                q.next[4:1] = q[3:]
                q.next[0] = not q[3]
            else:
                q.next[3:] = q[4:1]
                q.next[3] = not q[0]

    return logic
