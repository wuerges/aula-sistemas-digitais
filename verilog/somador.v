
// somador combinacional de 8 bits

module soma1bit (
    input a, 
    input b,
    input c_in,
    output out,
    output c_out);

    reg o, c;
    assign out = o;
    assign c_out = c;
    
    always @(a, b, c_in) begin
        case ({a, b, c_in})
            3'b000: begin
                o <= 0;
                c <= 0;
            end
            3'b001: begin
                o <= 1;
                c <= 0;
            end
            3'b010: begin
                o <= 1;
                c <= 0;
            end
            3'b011: begin
                o <= 0;
                c <= 1;
            end
            3'b100: begin
                o <= 1;
                c <= 0;
            end
            3'b101: begin
                o <= 0;
                c <= 1;
            end
            3'b110: begin
                o <= 0;
                c <= 1;
            end
            3'b111: begin
                o <= 1;
                c <= 1;
            end
        endcase
    end

endmodule


module soma4bits(
    input [3:0] a,
    input [3:0] b,
    output [3:0] o_out,
    output c_out);

wire carry0;
wire carry1;
wire carry2;

soma1bit S1(a[0], b[0], 1'b0 , o_out[0], carry0);
soma1bit S2(a[1], b[1], carry0, o_out[1], carry1);
soma1bit S3(a[2], b[2], carry1, o_out[2], carry2);
soma1bit S4(a[3], b[3], carry2, o_out[3], c_out);

endmodule



module test;

reg [3:0] a;
reg [3:0] b;
wire [3:0] o;
wire c;

soma4bits S1(a, b, o, c);

initial begin
    $dumpvars(0, S1);
    a <= 0;
    b <= 0;
#2
    a <= 10;
    b <= 6;
#2
    a <= 9;
    b <= 2;
#2
    a <= 4;
    b <= 2;
#2;
$finish;
end



endmodule
