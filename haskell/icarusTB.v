module icarusTB;
    reg clk, rst;
    wire o;

    Blinker_topEntity_0 B(clk, rst, o);

    always #2 clk = ~clk;

    initial begin
        $dumpvars(0, B);
        #10
        clk <= 0;
        rst <= 0;
        #20
        rst <= 1;
        #5000
        $finish;
    end
endmodule


