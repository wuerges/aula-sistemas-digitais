// Automatically generated Verilog-2001
module Blinker_counter_zdscounter_1(// clock
                                   system1000
                                   ,// asynchronous reset: active low
                                   system1000_rstn
                                   ,wrap_o);
  input system1000;
  input system1000_rstn;
  output [0:0] wrap_o;
  wire [25:0] x_0;
  wire [25:0] bodyVar_1;
  wire [25:0] s_2;
  wire [0:0] wrap_o_sig;
  wire [25:0] tmp_7;
  assign x_0 = s_2 + 26'd1;
  
  reg [25:0] bodyVar_1_reg;
  always @(*) begin
    if(wrap_o_sig)
      bodyVar_1_reg = 26'd0;
    else
      bodyVar_1_reg = x_0;
  end
  assign bodyVar_1 = bodyVar_1_reg;
  
  // register begin
  reg [25:0] n_9;
  
  always @(posedge system1000 or negedge system1000_rstn) begin : register_Blinker_counter_zdscounter_1_n_10
    if (~ system1000_rstn) begin
      n_9 <= 26'd0;
    end else begin
      n_9 <= bodyVar_1;
    end
  end
  
  assign tmp_7 = n_9;
  // register end
  
  assign s_2 = tmp_7;
  
  assign wrap_o_sig = s_2 == ((26'd50 * 26'd1024) * 26'd1024);
  
  assign wrap_o = wrap_o_sig;
endmodule
