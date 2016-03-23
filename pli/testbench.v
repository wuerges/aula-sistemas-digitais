module top;

integer data_file;
integer value;

logic signed [9:0] Iptx;
logic signed [9:0] Ipty;
logic signed [9:0] Ip1x;
logic signed [9:0] Ip1y;
logic signed [9:0] Ip2x;
logic signed [9:0] Ip2y;
logic signed [9:0] Ip3x;
logic signed [9:0] Ip3y;

reg signed [9:0] ptx;
reg signed [9:0] pty;
reg signed [9:0] p1x;
reg signed [9:0] p1y;
reg signed [9:0] p2x;
reg signed [9:0] p2y;
reg signed [9:0] p3x;
reg signed [9:0] p3y;
wire inside;

triangle T(ptx, pty, p1x, p1y, p2x, p2y, p3x, p3y, inside);

initial begin
  data_file = $fopen("data_file.dat", "r");
  if (data_file == 0) begin
    $display("data_file handle was 0");
    $finish;
  end else begin
    //$display("data_file is open");
  end
end

always #2 begin
  if (!$feof(data_file)) begin
    value = $fscanf(data_file, "%d %d %d %d %d %d %d %d\n", 
      ptx, pty, p1x, p1y, p2x, p2y, p3x, p3y); 
    $display("%d", inside);
  end 
  else begin
    $finish;
  end
end

endmodule
