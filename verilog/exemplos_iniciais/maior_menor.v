
module maior_menor(
    input [7:0] A,
    input [7:0] B,
    output [7:0] C);

reg [7:0] C_reg;
wire m;

assign m = A < B;
assign C = C_reg;

always @(m, A, B) begin
    if (m) begin
        C_reg <= B;
    end
    else begin
        C_reg <= A;
    end
end

endmodule


// outro modulo, para testar

module maior_4(
    input [7:0] A,
    input [7:0] B,
    input [7:0] C,
    input [7:0] D,
    output [7:0] Z
);

wire [7:0] X;
wire [7:0] Y;

maior_menor m1(A, B, X);
maior_menor m2(C, D, Y);
maior_menor m3(X, Y, Z);

endmodule


module test;

reg [7:0] A;
reg [7:0] B;
reg [7:0] C;
reg [7:0] D;

wire [7:0] Z;

maior_4 x1(A, B, C, D, Z);

initial begin
    $dumpvars;
    #2 A <= 5;
    #2 B <= 6;
    #2 C <= 7;
    #2 D <= 3;
    #2 A <= 10;
    #2 B <= 6;
    #2 C <= 7;
    #2 A <= 10;
    #2 B <= 15;
    #2 C <= 7;
    #2 D <= 20;
    #4;
end

endmodule



