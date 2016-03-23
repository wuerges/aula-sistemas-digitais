

module top;

integer               data_file    ;
integer               value        ;
logic   signed [21:0] captured_data;

reg clk = 0;

always #2 clk <= ~clk;

initial begin
  data_file = $fopen("data_file.dat", "r");
  if (data_file == 0) begin
    $display("data_file handle was 0");
    $finish;
  end else begin
    $display("data_file is open");
  end
end

always @(posedge clk) begin
  if (!$feof(data_file)) begin
    value = $fscanf(data_file, "%d\n", captured_data); 
    $display("read value: %d", value);

    // Usar o valor lido da entrada aqui
    //

  end 
  else begin
    $finish;
  end
end

endmodule
