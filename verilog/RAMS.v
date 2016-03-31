

module RAM_async(
  input [5:0] address,
  inout [11:0] data,
  input w
);

reg [11:0] mem [0:31];

assign data = w ? 11'bZZZZZZZZZZZ : mem[address];

always @(w) begin
  mem[address] <= data;
end

endmodule


module RAM_sync_single_port(
  input clk,
  input [5:0] address,
  inout [11:0] data,
  input w
);

reg [11:0] mem [0:31];

assign data = w ? 11'bzzzzzzzzzzz : mem[address];

always @(posedge clk) begin
  if(w)
    mem[address] <= data;
end

endmodule

module tb_RAM_async;

reg clk = 0;

reg [5:0] addr;
wire [11:0] data;
reg w;

reg [11:0] data_r;

assign data = w ? data_r : 11'bzzzzzzzzzzz;

// RAM_async R(addr, data, w);
RAM_sync_single_port R(clk, addr, data, w);

always #1 clk <= ~clk;

initial begin
$dumpvars(0, R, data_r, data, w);

#2 
addr <= 2;
data_r <= 10;
w <= 1;
#2
w <= 0;
#2
addr <= 3;
#2
data_r  <= 20;
#2
w <= 1;
#2 
w <= 0;
#2;
addr <= 2;
#2;
addr <= 3;
#2;


#300 $finish;
end


endmodule
