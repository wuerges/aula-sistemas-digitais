// Automatically generated Verilog-2001
module blinkLeds(// clock
                system1000
                ,// asynchronous reset: active low
                system1000_rstn
                ,LEDG);
  input system1000;
  input system1000_rstn;
  output [0:0] LEDG;
  Blinker_topEntity_0 Blinker_topEntity_0_inst
  (.system1000 (system1000)
  ,.system1000_rstn (system1000_rstn)
  ,.topLet_o (LEDG));
endmodule
