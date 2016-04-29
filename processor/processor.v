

module mem_inst(
  input         clk,
  input  [31:0] addr,
  output [31:0] instruction
);

reg [31:0] memory [511:0];

reg [31:0] value;

assign instruction = value;

always @(posedge clk) begin
  value <= memory[addr];
end

endmodule

module mem_registradores(
  input         clk,
  input         w,
  input  [4:0]  dst1,
  input  [4:0]  src1,
  input  [4:0]  src2,
  output [31:0] v1,
  output [31:0] v2,
  input  [31:0] t1);

reg [31:0] memory [31:0];

assign v1 = memory[src1];
assign v2 = memory[src2];

always @(posedge clk) begin
  if (w) begin
    memory[dst1] <= t1;
  end
end

endmodule

module inst_decoder(
  input [31:0] instruction,
  output b,
  output w,
  output op,
  output i,
  output [4:0] imm,
  output [4:0] dst1,
  output [4:0] src1,
  output [4:0] src2);

  // TODO

endmodule


module processor(
  input clk,
  input [31:0] instruction,
  output [31:0] instruction_addr);

  wire b, w, op, i;
  wire [4:0] imm;
  wire [4:0] dst1;
  wire [4:0] src1;
  wire [4:0] src2;

  inst_decoder D(
    instruction, 
    b, 
    w, 
    op, 
    i, 
    imm, 
    dst1, 
    src1, 
    src2);


  endmodule
