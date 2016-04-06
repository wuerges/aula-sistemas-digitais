module Counter(
  input clk,
  input w,
  input cond,
  output [10:0] count
);

reg [10:0] c = 0;

assign count = c;

always @(posedge clk) 
begin
  if (w)
    c <= 0;
  else 
    if (cond) 
      c <= c + 1'b1;
end

endmodule

module MEM(
  input clk,
  input we,
  input [5:0] RA,
  output [8:0] RV,
  input [5:0] WA,
  input  [8:0] WV
);

reg [8:0] data [63:0];

assign RV = data[RA];

always @(posedge clk) begin
	if (we)
		data[WA] <= WV;
end

endmodule

module VGA(
  input clk,
  output [3:0] r,
  output [3:0] g,
  output [3:0] b,
  output h_sync,
  output v_sync,
  output [10:0] X,
  output [10:0] Y,
  input [11:0] D
);

wire [10:0] count_h;
wire [10:0] count_v;
wire w_h;
wire w_v;

assign w_h = count_h == 1040;
assign w_v = count_v == 666;

Counter H(clk, w_h, 1'b1, count_h);
Counter V(clk, w_v, w_h, count_v);

wire visible_h, visible_v, visible;

assign visible_h = (count_h > 240) & (count_h < 1040);
assign visible_v = (count_v > 66) & (count_v < 666);
assign visible = visible_h & visible_v;

assign X = count_h - 10'd240;
assign Y = count_v - 10'd240;

assign r = visible ? D[3:0]  : 4'h0;
assign g = visible ? D[7:4]  : 4'h0;
assign b = visible ? D[11:8] : 4'h0;

assign h_sync = (count_h > 56) & (count_h < 176);
assign v_sync = (count_v > 37) & (count_v < 43);


endmodule

module vgatop2 (
  input CLOCK_50,
  input [9:0] SW,
  input [3:0] KEY,
  output [3:0] VGA_R,
  output [3:0] VGA_G,
  output [3:0] VGA_B,
  output VGA_HS,
  output VGA_VS
);

wire [10:0] X;
wire [10:0] Y;
wire [11:0] V;

VGA v(CLOCK_50, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS, X, Y, V);

wire we;
assign we = ~KEY[0];

wire [5:0] RA; // OK
wire [8:0] RV; // OK
reg [5:0] WA = 6'd0;
reg [8:0] WV = 6'd0;

assign RA = {X[2:0], Y[2:0]};
assign V = {RV[2:0], 1'b0, RV[5:3], 1'b0, RV[8:6], 1'b0};

MEM M(CLOCK_50, we, RA, RV, WA, WV);

always @(posedge CLOCK_50)
begin
	if (~KEY[1]) begin
		WA <= SW;
	end if (~KEY[2]) begin
		WV <= SW;
	end else begin
	end
end

endmodule
