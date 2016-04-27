module SumAcc(
  input reset,
  input clk,
  input step,
  input [31:0] A,
  input [31:0] B,
  output [63:0] R,
  output valid);

  reg [63:0] R_reg = 0;
  reg [5:0] count = 0;

  reg [5:0] state = 0;

  assign R = R_reg;
  assign valid = count == 10;

always @(posedge clk) begin
  if (reset)
  begin
    R_reg <= 0;
    count <= 0;
    state <= 0;
  end
  else begin
    case (state)
      0: begin
        if (~valid & step) begin
          R_reg <= R_reg + (A * B);
          count <= count + 1;
          state <= 1;
        end
      end
      1: begin
        if (~step) begin
          state <= 0;
        end
      end
    endcase
  end
end

endmodule

module test;

reg clk = 0;
always #1 clk <= ~clk;

reg step = 0;
always #13 step <= ~step;
reg rst = 1;

reg [31:0] A;
reg [31:0] B;

wire [63:0] R;
wire valid;

SumAcc S(rst, clk, step, A, B, R, valid);

initial begin
  $dumpvars(0, S);
#10
rst <= 0;
#1;
A <= 10;
B <= 5;

#300;
rst <= 1;
#10;
rst <= 0;

#5000;

$finish;

end


endmodule

