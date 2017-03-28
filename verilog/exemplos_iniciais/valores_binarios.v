module test;

reg [1:0] r;

initial begin
	$dumpvars(0, r);

	#2 r <= 0;
	#2 r <= 1;
	#2 r <= 2;
	#2 r <= 12;
	#2;
	#2 r <= 2'b00;
	#2 r <= 2'b01;
	#2 r <= 2'b10;
	#2 r <= 2'b11;
	#2;
end


endmodule

