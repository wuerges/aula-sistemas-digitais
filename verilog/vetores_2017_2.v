module multv(
    input clk,
    input [9:0] x,
    input [9:0] y,
    input reset,
    input enable,
    output [19:0] saida
);


reg [19:0] acumulador = 0;
assign saida = acumulador;

always @(posedge clk) begin
    if(reset) begin
        acumulador <= 0;
    end
    else begin
        if (enable) begin
            acumulador <= acumulador + (x * y);
        end
//        else begin
  //          acumulador <= acumulador;
    //    end
    end
end



endmodule


module testbench;

    reg clk = 0;
    reg [9:0] x;
    reg [9:0] y;
    reg reset, enable;
    wire [19:0] saida;

    multv M1(clk, x, y, reset, enable, saida);


always #2 clk = ~clk;

initial begin
    $dumpvars;
    #10
    reset <= 1;
    #8
    enable <= 1;
    reset <= 0;
    x <= 1;
    y <= 4;
    #4
    x <= 2;
    y <= 5;
    #4
    x <= 3;
    y <= 6;
    #4
    enable <= 0;
   #100;
    $finish;
end    

endmodule


