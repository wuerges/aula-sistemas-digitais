module top;

integer data_file;
integer value;

reg signed [10:0] ptx;
reg signed [10:0] pty;
reg signed [10:0] p1x;
reg signed [10:0] p1y;
reg signed [10:0] p2x;
reg signed [10:0] p2y;
reg signed [10:0] p3x;
reg signed [10:0] p3y;
wire inside;

triangle T(ptx, pty, p1x, p1y, p2x, p2y, p3x, p3y, inside);

initial begin
  data_file = $fopen("triangle_input_data.dat", "r");
  if (data_file == 0) begin
    $display("data_file handle was 0");
    $finish;
  end else begin
    //$display("data_file is open");
  end
end

always #2 begin
  if (!$feof(data_file)) begin
    $display("%d %d %d %d %d %d %d %d = %d", 
      ptx, pty, p1x, p1y, p2x, p2y, p3x, p3y,
      inside);
    value = $fscanf(data_file, "%d %d %d %d %d %d %d %d\n", 
      ptx, pty, p1x, p1y, p2x, p2y, p3x, p3y); 
  end 
  else begin
    $finish;
  end
end

endmodule
