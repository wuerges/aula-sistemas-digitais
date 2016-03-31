

module ROM_case(
  input [9:0] address,
  output [11:0] data
);

reg [11:0] data_val;
assign data = data_val;


always @(address) begin
  case (address)
    0 : data_val = 10;
    1 : data_val = 55;
    2 : data_val = 244;
    3 : data_val = 0;
    4 : data_val = 1;
    5 : data_val = 12'hff;
    6 : data_val = 12'h11;
    7 : data_val = 12'h1;
    8 : data_val = 12'h10;
    9 : data_val = 12'h0;
    10 : data_val = 12'h10;
    11 : data_val = 12'h15;
    12 : data_val = 12'h60;
    13 : data_val = 12'h90;
    14 : data_val = 12'h70;
    15 : data_val = 12'h90;
  endcase
end

endmodule

module ROM_file(
  input [9:0] address_x,
  input [9:0] address_y,
  output [11:0] data
);

reg [11:0] mem [0:9] [0:19];

assign data = mem[address_x][address_y];

initial begin
  $readmemh("memory.list", mem); // memory_list is memory file
end

endmodule

module tb_ROM_file;

reg [9:0] i;
reg [9:0] j;
wire [11:0] data;

ROM_file R(i, j, data);


initial begin
 $dumpvars(0, R);
  for (i = 0; i < 10; i = i + 1)
    for (j = 0; j < 20; j = j + 1)
      #2;

      // $display("i = %d, j = %d, data = %d", i, j, data);
end

endmodule
