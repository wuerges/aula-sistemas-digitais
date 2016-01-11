
module test_clock;
  reg clk;

  always #2 clk = ~clk;

  initial begin
    $dumpvars(0, clk);
    clk <= 0;
    #500;
    $finish;
  end

endmodule
