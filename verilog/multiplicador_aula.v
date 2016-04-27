

module mult(
    input clk,
    input e,
    input [5:0] a,
    input [5:0] b,
    output [11:0] c,
    output valid
);

reg [11:0] total;
assign c = total;

reg [2:0] count = 0;

wire [5:0] r;

assign r = { a[count]
           , a[count]
           , a[count]
           , a[count]
           , a[count]
           , a[count] } & b;

assign valid = count == 7;

always @(posedge clk) begin
    if (e) begin
        count <= count - 1;
        total <= (total << 1) + r;
    end
    else begin
        count <= 5;
        total <= 0;
    end

end


endmodule


module test;

reg clk = 0; 
reg e;
reg [5:0] a;
reg [5:0] b;
wire [11:0] c;
wire valid;

always #2 clk <= ~clk;

mult M(clk, 
    e, a, b, c, valid);

initial begin
    $dumpvars(0, M);
    e <= 0;
#10;
a <= 11;
b <= 13;
e <= 1;
#50;
e <= 0;
#10;
a <= 63;
b <= 63;
e <= 1;
#50;
e <= 0;
#10;
a <= -1;
b <= 25;
e <= 1;

#50;
$finish;
end



endmodule
