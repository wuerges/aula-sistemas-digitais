

module signP(
  input clk,
  input [10:0] i1,
  input [10:0] i2,
  input r,
  output s
);

  reg [4:0] state;

  reg [10:0] ptx;
  reg [10:0] pty;
  reg [10:0] p1x;
  reg [10:0] p1y;
  reg [10:0] p2x;
  reg [10:0] p2y;
  reg [10:0] p3x;
  reg [10:0] p3y;

  wire signed [11:0] t1;
  wire signed [11:0] t2;
  wire signed [11:0] t3;
  wire signed [11:0] t4;

  reg signed [11:0] r_t1;
  reg signed [11:0] r_t2;
  reg signed [11:0] r_t3;
  reg signed [11:0] r_t4;

  wire signed [23:0] m1;
  wire signed [23:0] m2;

  reg signed [23:0] r_m1;
  reg signed [23:0] r_m2;

  assign t1 = ptx - p3x; // p1x changed to ptx
  assign t2 = p2y - p3y;
  assign t3 = p2x - p3x;
  assign t4 = pty - p3y; // p1y changed to p1y

  assign m1 = r_t1 * r_t2; // inputs are now registers
  assign m2 = r_t3 * r_t4;

  assign s = r_m1 < r_m2; // inputs are now registers
  reg r_s;


  always @(posedge clk) begin
    if (r)
      state <= 0;
    else begin
      case (state)
        0: begin
          state <= 1;
          p1x <= i1;
          p1y <= i2;
        end
        1: begin
          state <= 2;
          p2x <= i1;
          p2y <= i2;
        end
        2: begin
          state <= 3;
          p3x <= i1;
          p3y <= i2;
        end
        3: begin
          state <= 4;
          ptx <= i1;
          pty <= i2;
        end
        4: begin // STATE A
          state <= 5;
          p1x <= p2x;
          p1y <= p2y;
          p2x <= p3x;
          p2y <= p3y;
          p3x <= p1x;
          p3y <= p1y;
        end
        5: begin // STATE B
          state <= 6;
          r_t1 <= t1;
          r_t2 <= t2;
          r_t3 <= t3;
          r_t4 <= t4;
        end
        6: begin // STATE C
          state <= 7;
          r_m1 <= m1;
          r_m2 <= m2;
        end
        7: begin // STATE D
          state <= 3;
          r_s <= s;
        end
        default: 
          state <= 0;
      endcase
    end
  end

endmodule

