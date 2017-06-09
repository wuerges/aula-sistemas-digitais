
module sram_exemplo(
	input CLOCK_50,
	output [17:0] SRAM_ADDR,
	inout [15:0]  SRAM_DQ,
	output SRAM_WE_N,
	output SRAM_OE_N,
	output SRAM_UB_N ,
	output SRAM_LB_N,
	output SRAM_CE_N ,
	input [3:0] KEY,
	output [7:0] LEDG,
	output [9:0] LEDR
);


reg write = 0;
reg [15:0] data;

assign SRAM_ADDR = 0;

reg [9:0] count = 0;
assign LEDR = count;
assign LEDG = 8'hAA;

assign SRAM_DQ = write ? data : 16'hzzzz;

assign SRAM_UB_N = 0;
assign SRAM_LB_N = 0;
assign SRAM_CE_N = 0;

assign SRAM_WE = ~write;
assign SRAM_OE = write;

reg init = 1;
reg [1:0] st = 0;
reg [17:0] cnt = 0;

always @(posedge CLOCK_50) begin
	if(init) begin
		case(st) begin
			0: begin
				if (x == maxy & y == maxy) begin
					init = 0;
				end
				SRAM_ADDR <= {x,y};
				y <= y + 1;
				st <= 1;
			end	
			1: begin
				write <= 1;
				data <= o;
				st <= 2;
			end
			2: begin
				
				st <= 3;
			end
			3: begin
				write <= 0;
				st <= 3;
			end
			
		endcase
	end
end

always @(posedge CLOCK_50) begin
	if (~KEY[0]) begin
		write <= 1;
		data <= count;	
	end
	else begin
		write <= 0;
		if(~KEY[1]) begin
			count <= SRAM_DQ;
		end
		else if (~KEY[2]) begin
			count <= count + 1;
		end
		else if (~KEY[3]) begin
			count <= count - 1;
		end

	end
end

/*always @(posedge KEY[1] or posedge KEY[2] or posedge KEY[3]) begin
	if (~write) begin
		count <= SRAM_DQ;
	end
	else 
	begin 
		if (KEY[2]) begin
			count <= count + 1;
		end
		else if (KEY[3]) begin
			count <= count - 1;
		end
	end
end
*/
endmodule
