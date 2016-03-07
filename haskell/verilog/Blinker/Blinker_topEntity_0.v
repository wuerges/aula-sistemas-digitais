// Automatically generated Verilog-2001
module Blinker_topEntity_0(x_i1
                          ,// clock
                          system1000
                          ,// asynchronous reset: active low
                          system1000_rstn
                          ,topLet_o);
  input [0:0] x_i1;
  input system1000;
  input system1000_rstn;
  output [0:0] topLet_o;
  wire [0:0] repANF_0;
  Blinker_blinker_1 Blinker_blinker_1_repANF_0
  (.s_o (repANF_0)
  ,.system1000 (system1000)
  ,.system1000_rstn (system1000_rstn)
  ,.i_i1 (x_i1));
  
  Blinker_counter_zdscounter_2 Blinker_counter_zdscounter_2_topLet_o
  (.bodyVar_o (topLet_o)
  ,.system1000 (system1000)
  ,.system1000_rstn (system1000_rstn)
  ,.eta_i1 (repANF_0));
endmodule
