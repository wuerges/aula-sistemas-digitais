module top;
  reg clk = 0;
  reg re;
  reg [10:0] i1;
  reg [10:0] i2;
  reg reset;

  wire s;

  signP P(clk, re, i1, i2, reset, s);

  always #2 clk <= ~clk;

  initial begin
    $dumpvars(0, P);
    reset <= 1;
#10;
    reset <= 0;
    // 178   168    10    10   200   100   300   300 = 1
    // 795    22    10    10   200   100   300   300 = 0
    re <= 0;
    i1 <= 10;
    i2 <= 10;
#12;
    re <= 0;
    i1 <= 200;
    i2 <= 100;
#14;
    re <= 0;
    i1 <= 300;
    i2 <= 300;
#16;
    re <= 1;
    i1 <= 178;
    i2 <= 168;
#18;
    re <= 0;
#20;
#22;
#24;
#26;
#28;
#30;

    $finish;
  end
endmodule


