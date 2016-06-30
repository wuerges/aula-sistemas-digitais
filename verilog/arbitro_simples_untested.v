
module arbiter(
    input CLOCK_50,
    input  [17:0] w_addr,
    input  [15:0] w_data,
    input  [17:0] r_addr,
    output [15:0] r_data,

    output [17:0] SRAM_ADDR,
    inout [15:0] SRAM_DQ,
    output SRAM_WE_N,
    output SRAM_OE_N,
    output SRAM_UB_N,
    output SRAM_LB_N,
    output SRAM_CE_N 

);

reg state = 0;
assign SRAM_WE_N = state;
assign SRAM_OE_N = 0;
assign SRAM_UB_N = 0;
assign SRAM_LB_N = 0;
assign SRAM_CE_N = 0;

reg [15:0] reg_r_data;

reg [17:0] reg_addr;
reg [15:0] reg_dq;

assign SRAM_ADDR = reg_addr;

assign SRAM_DQ = reg_dq;


always @(posedge CLOCK_50) 
begin

    case (state)
        0: begin
            reg_addr <= r_addr;
            reg_dq <= 16'hzzzz;
            state <= 1;
        end
        1: begin
            reg_r_data <= SRAM_DQ;
            reg_addr <= w_addr;
            reg_dq <= w_data;
            state <= 0;
        end
    endcase
end


endmodule
