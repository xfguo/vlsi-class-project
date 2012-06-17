module alu(
input 		mode_control_i,
input	[3:0]	select_input_i,

input	[3:0]	operand_a_i,
input	[3:0]	operand_b_i,
input		carry_input_i,

output	[3:0]	function_output_o,
output		generate_output_o,
output		propagate_output_o,
output		carry_output_o,
output		cmp_output_o
);

reg	[4:0]	carry;
reg	[3:0]	prop;
reg	[3:0]	gen;
reg		group_gen;
reg		group_prop;

// Sum & Carry
always @(*) begin
	gen	= ~((select_input_i[3]?(operand_a_i & operand_b_i):4'd0) | (select_input_i[2]?(operand_a_i & ~operand_b_i):4'd0));
	prop	= ~((select_input_i[1]?(~operand_b_i):4'd0) | (select_input_i[0]?operand_b_i:4'd0) | operand_a_i);
end

/*
always @(*) begin
	carry[0]	= ~carry_input_i;
	for(i = 0;i < 4;i=i+1) begin
		carry[i+1]	= gen[i] | (prop[i] & carry[i]);
		sum[i]		= prop[i] ^ carry[i];
	end
	sum[4]		= carry[4];
end
*/
always @(*) begin
	carry[0] = ~carry_input_i;
	carry[1] = ~(prop[0] | (carry_input_i & gen[0]));
	carry[2] = ~(
		prop[1] | 
		(prop[0] & gen[1]) | 
		(carry_input_i & gen[0] & gen[1])
		);
	carry[3] = ~(
		prop[2] |
		(prop[1] & gen[2]) |
		(prop[0] & gen[1] & gen[2]) |
		(carry_input_i & gen[0] & gen[1] & gen[2])
		);
	group_gen = &gen;
	group_prop = ~(
		prop[3] |
		(prop[2] & gen[3]) |
		(prop[1] & gen[2] & gen[3]) |
		(carry_input_i & gen[1] & gen[2] & gen[3])
		);

	carry[4] = ~(
		group_prop &
		~(group_gen & carry_input_i)
		);
end
assign	generate_output_o = ~group_gen;
assign	propagate_output_o = group_prop;
assign	function_output_o = (prop ^ gen) ^ ({4{mode_control_i}}|carry[3:0]);
assign	carry_output_o = carry[4];
assign	cmp_output_o = &function_output_o;
/*


0000	~a		a - 1			a			
0001	~(a&b)		(a&b) - 1		a&b			
0010	(~a)|b		(a&~b) - 1		a&~b			
0011	1		-1			0			
0100	~(a|b)		a + (a|~b)		a + (a|~b) + 1		
0101	~b		(a&b) + (a|~b)		(a&b) + (a|b~) + 1	
0110	~(a^b)		a - b - 1		a - b			
0111	a|~b		a|~b			(a|~b) + 1		
1000	~a&b		a + (a|b)		a + (a|b) + 1		
1001	a^b		a + b			a + b + 1		
1010	b		(a&~b) + (a&b)		(a&~b) + (a&b) + 1	
1011	a|b		a | b			(a|b) + 1		
1000	0		a + a			a + a + 1		
1101	a&~b		(a&b) + a		(a&b) + a + 1		
1110	a&b		(a&~b) + a		(a&~b) + a + 1		
1111	a		a			a + 1			

0000	~a		a		a+1
0001	~(a|b)		a|b		(a|b)+1
0010	~a&b		a|~b		(a|~b)+1
0011	0		-1		0
0100	~(a&b)		a + (a&~b)	a+(a&~b)+1
0101	~b		(a|b)+(a&~b)	(a|b)+(a&~b)+1	
0110	a^b		a-b-1		a-b
0111	a&~b		(a&~b)-1	(a&~b)
1000	~a|b		a+(a&b)		a+(a&b)+1	
1001	~(a^b)		a+b		a+b+1
1010	b		(a|~b)+(a&b)	(a|~b)+(a&b)+1
1011	a&b		(a&b)-1		(a&b)	
1000	1		a+a		a+a+1
1101	a|~b		(a|b) + a	(a|b) + a +1	
1110	a|b		(a|~b) + a	(a|~b) + a+1	
1111	a		a-1		a
*/

endmodule
