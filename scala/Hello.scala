import Chisel._

class Monoid extends Bundle {
  val a = UInt(INPUT, 16)
  val b = UInt(INPUT, 16)
  val c = UInt(OUTPUT, 16)
}

class Adder extends Module {
  val io = new Monoid()

  val x = Reg(UInt())
  x := io.a + io.b
  io.c <> x
}

class Multiplier extends Module {
  val io = new Monoid {
    val valid = Bool(OUTPUT)
    val ready = Bool(INPUT)
  }

  val shift = Reg(UInt(width=log2Up(16)))
  val r = Reg(UInt(width=16))

  when(io.ready) {
    shift := shift - UInt(1)
    r := (r << 1) + (Fill(16, io.a(shift)) & io.b)

  }.otherwise {
    shift := UInt(15)
    r := UInt(0)
  }

  when(shift === UInt(0)) {
    io.c := r
    io.valid := Bool(true)
  }.otherwise {
    io.c := UInt(0)
    io.valid := Bool(false)
  }
}

class MultTests(c: Multiplier) extends Tester(c) {
  step(1)
  poke(c.io.a, 7)
  poke(c.io.b, 13)
  poke(c.io.ready, false)
  step(1)
  poke(c.io.a, 7)
  poke(c.io.b, 13)
  poke(c.io.ready, true)
  for (i <- 0 until 16) {
    step(1)
    peek(c.r)
    peek(c.shift)
    peek(c.io)
  }
}


class AdderTests(c: Adder) extends Tester(c) {
  step(1)
  poke(c.io.a, 7)
  poke(c.io.b, 13)
  step(1)
  expect(c.io.c, 20)
}


object hello {
  def main(args: Array[String]): Unit = {
    chiselMainTest(Array[String]("--backend", "c", "--compile", "--test", "--genHarness"),
       () => Module(new Adder())){c => new AdderTests(c)}
    chiselMainTest(Array[String]("--backend", "c", "--compile", "--test", "--genHarness"),
       () => Module(new Multiplier())){c => new MultTests(c)}
    chiselMainTest(Array[String]("--backend", "v", "--genHarness"),
       () => Module(new Adder())){c => new AdderTests(c)}
    chiselMainTest(Array[String]("--backend", "v", "--genHarness"),
       () => Module(new Multiplier())){c => new MultTests(c)}
  }
}
