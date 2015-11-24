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
  val io = new Bundle{
    val a = UInt(INPUT, 16)
    val b = UInt(INPUT, 16)
    val c = UInt(OUTPUT, 16)
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
  }
}
