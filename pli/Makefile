all: diff

triangle_input_data.dat sign_input_data.dat triangle_output.dat sign_output.dat:
	python3 ../python/point_in_triangle.py

verilog_triangle_output.dat: triangle_input_data.dat
	iverilog triangle.v testbench.v -o triangle
	./triangle > verilog_triangle_output.dat

verilog_sign_output.dat: triangle_input_data.dat
	iverilog triangle.v sign_testbench.v -o sign
	./sign > verilog_sign_output.dat

diff: verilog_sign_output.dat verilog_triangle_output.dat
	diff verilog_sign_output.dat sign_output_data.dat || echo
	diff verilog_triangle_output.dat triangle_output_data.dat || echo

