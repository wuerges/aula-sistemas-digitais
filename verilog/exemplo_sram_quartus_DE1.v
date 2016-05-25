module testeMemoria(
input CLOCK_50,
output [7:0] LEDG,
output [7:0] LEDR,
output [17:0] SRAM_ADDR,
inout [15:0] SRAM_DQ,
output SRAM_WE_N,
output SRAM_OE_N,
output SRAM_UB_N,
output SRAM_LB_N,
output SRAM_CE_N 
);

wire [15:0] output_leds;

assign LEDR[7:0] = output_leds[15:8];
assign LEDG[7:0] = output_leds[7:0];

assign output_leds = SRAM_DQ;

assign SRAM_CE_N = 0;

reg [3:0] state;


reg [17:0] addr_reg;
reg [15:0] data_reg;

assign SRAM_ADDR = addr_reg;
assign SRAM_DQ = data_reg;


reg we, oe, ub, lb; //, ce;

assign SRAM_WE_N = we;
assign SRAM_OE_N = oe;
assign SRAM_UB_N = ub;
assign SRAM_LB_N = lb;
// assign SRAM_CE_N = ce;


always @(posedge CLOCK_50) begin

	case (state)
		0: begin
			state <= 2;
			addr_reg <= 13;
			data_reg <= 50;
			we <= 0;
			oe <= 1;
			ub <= 0;
			lb <= 0;					
		end
		1: begin
			state <= 2;
			addr_reg <= 13;
			data_reg <= 50;
			we <= 0;
			oe <= 1;
			ub <= 0;
			lb <= 0;					
		end
		2: begin
			state <= 2;
			addr_reg <= 13;
			data_reg <= 16'bzzzzzzzzzzzzzzzz;
			we <= 1;
			oe <= 0;
			ub <= 0;
			lb <= 0;							
		end
	endcase

end



endmodule
