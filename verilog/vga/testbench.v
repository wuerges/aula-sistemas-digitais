module testbench;

reg clk = 0;

always #1 clk <= ~clk;

vga v1(clk, r, g, b, hs, vs);

initial begin
	$dumpvars;
	#2000000;
	$finish;
end

endmodule
