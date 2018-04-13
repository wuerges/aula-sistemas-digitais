module prodv(
    input reset,
    input clock,
    input [7:0] a,
    input [7:0] b,
    output reg [13:0] s
);

always @(posedge clock) begin


    if (reset == 1) begin
        s <= 0;
    end
    else begin
        s <= s + (a * b);
    end

end


endmodule


module testbench;

reg [7:0] a;
reg [7:0] b;
reg reset = 1;
reg clock = 0;
wire [13:0] s;

prodv x(reset, clock, a, b, s);


always #2 clock <= ~clock;

initial begin
    $dumpvars;

#12

    a <= 2;
    b <= 3;
    reset <= 0;
#4
    a <= 4;
    b <= 6;
#4
    a <= 8;
    b <= 3;
#4;

    $finish;
    

end


endmodule
