// Automatically generated Verilog-2001
module blinkLeds(CLOCK_50
                ,KEY0
                ,LEDG);
  input [0:0] CLOCK_50;
  input [0:0] KEY0;
  output [0:0] LEDG;
  wire system1000;
  wire altpll50_locked;
  wire system1000_rstn;
  altpll50 altpll50_inst
  (.inclk0 (CLOCK_50(0))
  ,.c0 (system1000)
  ,.areset (not KEY0(0))
  ,.locked (altpll50_locked));
  
  // reset system1000_rstn is asynchronously asserted, but synchronously de-asserted
  reg n_0;
  reg n_1;
  
  always @(posedge system1000 or negedge altpll50_locked)
  if (~ altpll50_locked) begin
    n_0 <= 1'b0;
    n_1 <= 1'b0;
  end else begin
    n_0 <= 1'b1;
    n_1 <= n_0;
  end
  
  assign system1000_rstn = n_1;
  
  Blinker_topEntity_0 Blinker_topEntity_0_inst
  (.system1000 (system1000)
  ,.system1000_rstn (system1000_rstn)
  ,.topLet_o (LEDG));
endmodule
