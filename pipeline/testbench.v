module top;
  reg clk;
  reg re;
  reg [10:0] i1;
  reg [10:0] i2;
  reg reset;

  wire s;

  signP P(clk, re, i1, i2, reset, s);

  always #10 clk <= ~clk;

  initial begin
#0;
clk <= 0;
    $dumpvars(0, P);
    reset <= 1;
#20;
    reset <= 0;
    // 178   168    10    10   200   100   300   300 = 1
    // 795    22    10    10   200   100   300   300 = 0
    re <= 0;
    i1 <= 10;
    i2 <= 10;
#20;
    re <= 0;
    i1 <= 200;
    i2 <= 100;
#20;
    re <= 0;
    i1 <= 300;
    i2 <= 300;
#20;
    re <= 1;
    i1 <= 178;
    i2 <= 168;
#20;
#20;
#20;
    re <= 1;
    i1 <= 795;
    i2 <= 22;
#20;
#20;
#20;
#50;
    re <= 0;
#60;
#70;

#500;

    $finish;
  end
endmodule


