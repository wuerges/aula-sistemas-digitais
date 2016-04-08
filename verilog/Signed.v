

module testsigned;
    reg [3:0] a;
    reg [3:0] b;
    wire [4:0] c;

    assign c = a + b;

    reg signed [3:0] s_a;
    reg signed [3:0] s_b;
    wire signed [4:0] s_c;

    assign s_c = s_a + s_b;

    integer i;
    integer j;

    initial begin
        $dumpvars(0, a, b, c, s_a, s_b, s_c);

        for (i = -4; i < 4; i = i + 1) begin 
            for (j = -4; j < 4; j = j + 1) begin 
                a <= i;
                s_a <= i;
                b <= j;
                s_b <= j;
                #2;
            end
        end

        $finish();
    end
endmodule
