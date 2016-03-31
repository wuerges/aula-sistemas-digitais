

module Mod(
  input  signed [11:0] i,
  output signed [11:0] o
  );

  assign o = i[11] ? -i : i;
endmodule


module tb;
  reg signed [11:0] i;
  wire signed [11:0] o;

  Mod M(i,o);

  integer t;

  initial begin
    for (t = -10; t < 10; t = t + 1) begin
      #1
      i <= t;
      $display("i = %d, o = %d", i, o);
    end
  end
endmodule
