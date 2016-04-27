
module mulSeq(
  input clk,
  input e,
  output valid,
  input [3:0] a,
  input [3:0] b,
  output [7:0] c
);


reg [7:0] total;

assign c = (count == 3) ? total : 0;

reg [1:0] count;

wire m1;
wire [3:0] m4;
wire [3:0] r;
assign m1 = b[count];
assign m4 = {m1, m1, m1, m1};
assign r = m4 & a;


always @(posedge clk) begin

  if (e) begin
    total <= (total << 1) + r;
    count <= count + 1;
  end
  else begin
    count <= 0;
    total <= 0;
  end

end

endmodule
  



module test;


reg clk = 0;
always #2 clk <= ~clk;

reg e;
wire valid;

reg [3:0] a;
reg [3:0] b;

wire [7:0] c;

mulSeq M(clk,e, valid, a, b, c);

initial begin
  $dumpvars(0, M);

  e<= 0;

#10;
a <= 3;
b <= 8;
e <= 1;

#30;
$finish;
end

endmodule

