// Automatically generated Verilog-2001
module Blinker_blinker_2(i_i1
                        ,// clock
                        system1000
                        ,// asynchronous reset: active low
                        system1000_rstn
                        ,s_o);
  input [0:0] i_i1;
  input system1000;
  input system1000_rstn;
  output [0:0] s_o;
  wire [0:0] altLet_0;
  wire [0:0] repANF_1;
  wire [0:0] s_o_sig;
  wire [0:0] tmp_2;
  reg [0:0] altLet_0_reg;
  always @(*) begin
    if(s_o_sig)
      altLet_0_reg = 1'b0;
    else
      altLet_0_reg = 1'b1;
  end
  assign altLet_0 = altLet_0_reg;
  
  reg [0:0] repANF_1_reg;
  always @(*) begin
    if(i_i1)
      repANF_1_reg = altLet_0;
    else
      repANF_1_reg = s_o_sig;
  end
  assign repANF_1 = repANF_1_reg;
  
  // register begin
  reg [0:0] n_3;
  
  always @(posedge system1000 or negedge system1000_rstn) begin : register_Blinker_blinker_2_n_4
    if (~ system1000_rstn) begin
      n_3 <= 1'b0;
    end else begin
      n_3 <= repANF_1;
    end
  end
  
  assign tmp_2 = n_3;
  // register end
  
  assign s_o_sig = tmp_2;
  
  assign s_o = s_o_sig;
endmodule
