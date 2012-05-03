module full_adder(
	a_i, b_i, cy_i, 
	y_o, cy_o
);
parameter	WIDTH = 8;
input	[WIDTH - 1:0]	a_i;
input	[WIDTH - 1:0]	b_i;
input			cy_i;

output	[WIDTH - 1:0] 	y_o;
output			cy_o;

assign {cy_o, y_o} = a_i + b_i + cy_i;
endmodule
