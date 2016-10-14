module tb_insideT;

wire out;
reg [9:0] ptx;
reg [9:0] pty;
reg [9:0] p1x;
reg [9:0] p1y;
reg [9:0] p2x;
reg [9:0] p2y;
reg [9:0] p3x;
reg [9:0] p3y;

initial begin
    $from_myhdl(
        ptx,
        pty,
        p1x,
        p1y,
        p2x,
        p2y,
        p3x,
        p3y
    );
    $to_myhdl(
        out
    );
end

insideT dut(
    out,
    ptx,
    pty,
    p1x,
    p1y,
    p2x,
    p2y,
    p3x,
    p3y
);

endmodule
