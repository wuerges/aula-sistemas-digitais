
module ppt(
    input [1:0] j1,
    input [1:0] j2,
    output j1_w,
    output j2_w);

reg [1:0] j_w_r;
assign j1_w = j_w_r[1];
assign j2_w = j_w_r[0];

always @(j1, j2) begin

    if(j1 == 2'b01) begin
        case (j2)
            2'b01: j_w_r <= 2'b00;
            2'b10: j_w_r <= 2'b01;
            2'b11: j_w_r <= 2'b10;
        endcase
    end
    if(j1 == 2'b10) begin
        case (j2)
            2'b01: j_w_r <= 2'b10;
            2'b10: j_w_r <= 2'b00;
            2'b11: j_w_r <= 2'b01;
        endcase
    end
    if(j1 == 2'b11) begin
        case (j2)
            2'b01: j_w_r <= 2'b01;
            2'b10: j_w_r <= 2'b10;
            2'b11: j_w_r <= 2'b00;
        endcase
    end

end


endmodule

module test;

reg [1:0] j1;
reg [1:0] j2;

wire j1_w;
wire j2_w;

ppt P(j1, j2, j1_w, j2_w);


initial begin
    $dumpvars;
#2 j1 <= 2'b01; j2 <= 2'b01;
#2 j1 <= 2'b01; j2 <= 2'b10;
#2 j1 <= 2'b01; j2 <= 2'b11;

#2 j1 <= 2'b10; j2 <= 2'b01;
#2 j1 <= 2'b10; j2 <= 2'b10;
#2 j1 <= 2'b10; j2 <= 2'b11;

#2 j1 <= 2'b11; j2 <= 2'b01;
#2 j1 <= 2'b11; j2 <= 2'b10;
#2 j1 <= 2'b11; j2 <= 2'b11;
#10;
end


endmodule



