
module counter(
    input c, 
    input reset,
    output [3:0] o); // contar ate 8

    reg [3:0] count;

    always @(reset)
        count <= 0;

    always @(posedge c) begin
        if (count <= 8)
            count <= count + 1;
        else
            count <= 0;
    end

    assign o = count;


endmodule


module test;



// wire r;
reg clk = 0;
reg rst;
wire [3:0] x;

counter C1(clk, rst, x);

always #2 begin
    clk <= ~clk;
end

initial begin
    $dumpvars(0, clk, C1);
    rst <= 1;
#1
    rst <= 0;
#500
    $finish;
end

endmodule
