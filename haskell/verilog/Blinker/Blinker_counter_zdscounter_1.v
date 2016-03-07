// Automatically generated Verilog-2001
module Blinker_counter_zdscounter_1(eta_i1
                                   ,// clock
                                   system1000
                                   ,// asynchronous reset: active low
                                   system1000_rstn
                                   ,bodyVar_o);
  input [0:0] eta_i1;
  input system1000;
  input system1000_rstn;
  output [0:0] bodyVar_o;
  wire [25:0] repANF_0;
  wire [25:0] s_1;
  wire [25:0] tmp_5;
  assign repANF_0 = s_1 + 26'd1;
  
  // regEn begin
  reg [25:0] n_7;
  
  always @(posedge system1000 or negedge system1000_rstn) begin : regEn_Blinker_counter_zdscounter_1_n_8
    if (~ system1000_rstn) begin
      n_7 <= 26'd0;
    end else begin
      if (eta_i1) begin
        n_7 <= repANF_0;
      end
    end
  end
  
  assign tmp_5 = n_7;
  // regEn end
  
  assign s_1 = tmp_5;
  
  assign bodyVar_o = s_1 == ((26'd50 * 26'd1024) * 26'd1024);
endmodule
