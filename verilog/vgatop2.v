module Counter(
  input clk,
  input w,
  input cond,
  output [10:0] count
);

reg [10:0] c = 0;

assign count = c;

always @(posedge clk) 
begin
  if (w)
    c <= 0;
  else 
    if (cond) 
      c <= c + 1'b1;
end

endmodule

module MEM(
  input [2:0] X,
  input [2:0] Y,
  output [3:0] r,
  output [3:0] g,
  output [3:0] b
);

reg [3:0] r_reg;
reg [3:0] g_reg;
reg [3:0] b_reg;

assign r = r_reg;
assign g = g_reg;
assign b = b_reg;

always @(*) begin
  case (Y)
    0: begin
      case (X)
        0: begin
          r_reg <= 4'hf;
          g_reg <= 4'hf;
          b_reg <= 4'hf;
        end
        1: begin
          r_reg <= 4'hf;
          g_reg <= 4'hf;
          b_reg <= 4'hf;
        end
        2: begin
          r_reg <= 4'h0;
          g_reg <= 4'hf;
          b_reg <= 4'hf;
        end
        3: begin
          r_reg <= 4'h0;
          g_reg <= 4'h0;
          b_reg <= 4'h0;
        end
        4: begin
          r_reg <= 4'h0;
          g_reg <= 4'h0;
          b_reg <= 4'h0;
        end
      endcase
    end
    1: begin
       case (X)
        0: begin
          r_reg <= 4'h0;
          g_reg <= 4'hf;
          b_reg <= 4'hf;
        end
        1: begin
          r_reg <= 4'hf;
          g_reg <= 4'hf;
          b_reg <= 4'hf;
        end
        2: begin
          r_reg <= 4'h0;
          g_reg <= 4'hf;
          b_reg <= 4'hf;
        end
        3: begin
          r_reg <= 4'h0;
          g_reg <= 4'hf;
          b_reg <= 4'hf;
        end
        4: begin
          r_reg <= 4'h0;
          g_reg <= 4'h0;
          b_reg <= 4'h0;
        end
      endcase
    end
    2: begin
        case (X)
        0: begin
          r_reg <= 4'hf;
          g_reg <= 4'h0;
          b_reg <= 4'h0;
        end
        1: begin
          r_reg <= 4'hf;
          g_reg <= 4'hf;
          b_reg <= 4'hf;
        end
        2: begin
          r_reg <= 4'hf;
          g_reg <= 4'hf;
          b_reg <= 4'hf;
        end
        3: begin
          r_reg <= 4'h0;
          g_reg <= 4'hf;
          b_reg <= 4'hf;
        end
        4: begin
          r_reg <= 4'h0;
          g_reg <= 4'hf;
          b_reg <= 4'hf;
        end
      endcase
   end
    3: begin
       case (X)
        0: begin
          r_reg <= 4'h0;
          g_reg <= 4'hf;
          b_reg <= 4'hf;
        end
        1: begin
          r_reg <= 4'h0;
          g_reg <= 4'hf;
          b_reg <= 4'hf;
        end
        2: begin
          r_reg <= 4'hf;
          g_reg <= 4'hf;
          b_reg <= 4'hf;
        end
        3: begin
          r_reg <= 4'hf;
          g_reg <= 4'hf;
          b_reg <= 4'hf;
        end
        4: begin
          r_reg <= 4'h0;
          g_reg <= 4'hf;
          b_reg <= 4'hf;
        end
      endcase
    end
    4: begin
       case (X)
        0: begin
          r_reg <= 4'h0;
          g_reg <= 4'h0;
          b_reg <= 4'h0;
        end
        1: begin
          r_reg <= 4'h0;
          g_reg <= 4'hf;
          b_reg <= 4'hf;
        end
        2: begin
          r_reg <= 4'h0;
          g_reg <= 4'hf;
          b_reg <= 4'hf;
        end
        3: begin
          r_reg <= 4'hf;
          g_reg <= 4'hf;
          b_reg <= 4'hf;
        end
        4: begin
          r_reg <= 4'h0;
          g_reg <= 4'h0;
          b_reg <= 4'h0;
        end
      endcase
    end
  endcase
end

endmodule

module VGA(
  input clk,
  output [3:0] r,
  output [3:0] g,
  output [3:0] b,
  output h_sync,
  output v_sync
);

wire [10:0] count_h;
wire [10:0] count_v;
wire [10:0] X;
wire [10:0] Y;
wire w_h;
wire w_v;

assign w_h = count_h == 1040;
assign w_v = count_v == 666;

Counter H(clk, w_h, 1'b1, count_h);
Counter V(clk, w_v, w_h, count_v);

wire visible_h, visible_v, visible;

assign visible_h = (count_h > 240) & (count_h < 1040);
assign visible_v = (count_v > 66) & (count_v < 666);
assign visible = visible_h & visible_v;

assign r = visible ? 4'hf : 4'h0;
assign g = visible ? 4'hf : 4'h0;
assign b = visible ? 4'h0 : 4'h0;

assign h_sync = (count_h > 56) & (count_h < 176);
assign v_sync = (count_v > 37) & (count_v < 43);

assign X = count_h - 10'd240;
assign Y = count_v - 10'd240;

endmodule

module vgatop2 (
  input CLOCK_50,
  output [3:0] VGA_R,
  output [3:0] VGA_G,
  output [3:0] VGA_B,
  output VGA_HS,
  output VGA_VS
);

VGA v(CLOCK_50, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS);

endmodule
