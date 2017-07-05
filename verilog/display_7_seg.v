module top (
	input [7:0] SW,
	input [3:0] KEY,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3
);

segs S1(SW[3:0], HEX0);
segs S2(SW[7:4], HEX1);
segs S3(SW[3:0] + SW[7:4], HEX2);

segs S4(KEY, HEX3);

endmodule

module segs (
	input [3:0] x,
	output [6:0] h
);

//assign HEX0 = 7'hff;
assign h[0] = x == 1 || x == 4;
assign h[1] = x == 5 || x == 6;
assign h[2] = x == 2 ;
assign h[3] = x == 1 || x == 4 || x == 7;
assign h[4] = x == 1 || x == 3 || x == 4 || x == 5 || x == 7 || x == 9;
assign h[5] = x == 1 || x == 2 || x == 3 || x == 7;
assign h[6] = x == 0 || x == 1 || x == 7;


endmodule
