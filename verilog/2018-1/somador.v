

module soma(
    input A,
    input B,
    input Cin,
    output S,
    output Cout
);

reg s_temp;
reg cout_temp;

wire [2:0] temp = {Cin, A, B};


always @(temp) begin
  case (temp)
    0: begin
	s_temp = 0; 
	cout_temp = 0; 
    end
    1: begin
	s_temp = 1; 
	cout_temp = 0; 
    end
    2: begin
	s_temp = 1; 
	cout_temp = 0; 
    end
    3: begin
	s_temp = 0; 
	cout_temp = 1; 
    end
    4: begin
	s_temp = 1; 
	cout_temp = 0; 
    end
    5: begin
	s_temp = 0; 
	cout_temp = 1; 
    end
    6: begin
	s_temp = 0; 
	cout_temp = 1; 
    end
    7: begin
	s_temp = 1; 
	cout_temp = 1; 
    end
  endcase
end

assign S = s_temp;
assign Cout = cout_temp;

endmodule


module testbench;

reg [1:0] rA;
reg [1:0] rB;
reg Cin;

wire [1:0] S;
wire [1:0] Cout;

soma X1(rA[0], rB[0], Cin, S[0], Cout[0]);
soma X2(rA[1], rB[1], Cout[0], S[1], Cout[1]);

initial begin
$dumpvars;
Cin = 0;

rA = 0; rB = 0; #2;
rA = 0; rB = 1; #2;
rA = 0; rB = 2; #2;
rA = 0; rB = 3; #2;
rA = 1; rB = 0; #2;
rA = 1; rB = 1; #2;
rA = 1; rB = 2; #2;
rA = 1; rB = 3; #2;
rA = 2; rB = 0; #2;
rA = 2; rB = 1; #2;
rA = 2; rB = 2; #2;
rA = 2; rB = 3; #2;
rA = 3; rB = 0; #2;
rA = 3; rB = 1; #2;
rA = 3; rB = 2; #2;
rA = 3; rB = 3; #2;


end

endmodule



