from myhdl import *


def leds(CLOCK_50, LEDR):

    led_reg = Signal(False)
    LEDR = led_reg
    count = Signal(modbv(0, min=0, max=2**32))


    @always(CLOCK_50.posedge)
    def counting():
        if count == 50000000:
            count.next = 0
            led_reg.next = ~led_reg 
        else:
            count.next = count + 1

    return instances()




sim = Simulation(leds(Signal(False), intbv(0)))
sim.run()

