
module batalha(
	input p1_a,
	input p1_b,
	input p1_c,
	input p2_a,
	input p2_b,
	input p2_c,
	output s1,
	output s2);


reg s2_r;

assign s2 = s2_r & ~s1;

reg [2:0] e;
wire [2:0] p1_bundle;
wire [2:0] p2_bundle;

assign p1_bundle = { p1_a, p1_b, p1_c };
assign p2_bundle = { p2_a, p2_b, p2_c };

always @(p1_bundle) begin
	case(p1_bundle)
		0: e <= 5;
		1: e <= 4;
		2: e <= 2;
		3: e <= 1;
		4: e <= 7;
		5: e <= 6;
		6: e <= 3;
		7: e <= 0;
	endcase
end

assign s1 = (p1_a == p1_b) & (p1_b == p1_c);

always @(e, p2_bundle)
begin
	s2_r <= e == p2_bundle;
end

endmodule


module test;

reg p1_a, p1_b, p1_c, p2_a, p2_b, p2_c;
wire s1, s2;

batalha B(p1_a, p1_b, p1_c, p2_a, p2_b, p2_c, s1, s2);


initial begin
	$dumpvars(0, B);
	#2;
	p1_a <= 0; p1_b <= 0; p1_c <= 0; p2_a <= 0; p2_b <= 0; p2_c <= 0;
	#2;
	p1_a <= 1; p1_b <= 1; p1_c <= 0; p2_a <= 1; p2_b <= 0; p2_c <= 1;
	#2;
	p1_a <= 0; p1_b <= 0; p1_c <= 1; p2_a <= 0; p2_b <= 1; p2_c <= 1;
	#2;
	p1_a <= 1; p1_b <= 1; p1_c <= 0; p2_a <= 0; p2_b <= 1; p2_c <= 1;
	#2;
end

endmodule
