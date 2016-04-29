

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

module alu(
  input [31:0] v1,
  input [31:0] v2,
  input [4:0]  op,
  output [31:0] alu_out);

reg [31:0] alu_out_reg;

assign alu_out = alu_out_reg;

always @(v1, v2, op) begin

  case(op)
    0: alu_out_reg <= v1 + v2;
    1: alu_out_reg <= v1 - v2;
    2: alu_out_reg <= v1 * v2;
    3: alu_out_reg <= v1 << v2;
    4: alu_out_reg <= v1 & v2;
    5: alu_out_reg <= v1 | v2;
  endcase

end
endmodule


module inst_decoder(
  input [31:0] instruction,
  output b, // ok
  output w, // ok
  output [4:0] op, //ok
  output i, //ok
  output [4:0] imm, // ok
  output [4:0] dst1, // ok
  output [4:0] src1, // ok
  output [4:0] src2); //ok


  assign op   = instruction[31:27];
  assign b    = instruction[26];
  assign w    = instruction[25];
  assign i    = instruction[24];
  assign dst1 = instruction[23:19];
  assign src1 = instruction[18:14];
  assign src2 = instruction[13:9];
  assign imm  = instruction[8:4];

endmodule


module processor(
  input clk,
  input [31:0] instruction,
  output [31:0] instruction_addr);

  wire b, w, i;
  wire [4:0] op;
  wire [4:0] imm;
  wire [4:0] dst1;
  wire [4:0] src1;
  wire [4:0] src2;
  wire [31:0] alu_out;
  wire [31:0] t1;
  wire [31:0] v1;
  wire [31:0] v2;

  assign t1 = i ? alu_out : imm;

  reg [31:0] pc;

  assign instruction_addr = pc;

  always @(posedge clk) begin
    if (b)
      pc <= pc + t1;
    else
      pc <= pc + 1;
  end

  mem_registradores R(
    clk,
    w,
    dst1,
    src1,
    src2,
    v1,
    v2,
    t1);

  alu A(
    v1,
    v2,
    op,
    alu_out);


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
