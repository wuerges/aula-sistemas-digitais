module Adder(input clk,
    input [15:0] io_a,
    input [15:0] io_b,
    output[15:0] io_c
);

  reg [15:0] x;

  assign io_c = x;

  always @(posedge clk) begin
    x <= io_a + io_b;
  end
endmodule

module test;
  reg clk;
  reg[15:0] io_a, io_b;
  wire[15:0] io_c;

  always #20 clk = ~clk;

  Adder A(clk, io_a, io_b, io_c);

  initial begin
    #0 clk <= 0;
    io_a <= 3;
    io_b <= 7;
    #100;
    $dumpvars(0, A);

    #500;
    $finish;
  end

endmodule
