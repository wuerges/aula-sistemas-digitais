// Automatically generated Verilog-2001
module quartusTop(CLOCK_50
                , KEY
                , LEDG);
					 
  input CLOCK_50;
  input [0:0] KEY;
  output [0:0] LEDG;
  
  blinkLeds B(CLOCK_50, KEY, LEDG);
endmodule
