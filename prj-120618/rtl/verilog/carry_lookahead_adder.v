module carry_lookahead_adder 
(
input	[3:0]	a_i,
input	[3:0]	b_i,

input		mode_i,
input	[3:0]	sel_i,

input		carry_i,

output	[3:0]	f_o,
output		carry_o,

output		gp,
output		gg
);

reg	[4:0]	sum;
reg	[4:0]	carry;
reg	[3:0]	prop;
reg	[3:0]	gen;
wire	[3:0]	gg_imm;

integer 	i;

// Sum & Carry
always @(*) begin
	gen		= ~((sel_i[3]?(a_i & b_i):4'd0) | (sel_i[2]?(a_i & ~b_i):4'd0));
	prop		= ~((sel_i[1]?(~b_i):4'b0) | (sel_i[0]?b_i:4'b0) | a_i);
	carry[0]		= 1'b0;
	for(i = 0;i < 4;i=i+1) begin
		carry[i+1]	= gen[i] | (prop[i] & carry[i]);
		sum[i]		= prop[i] ^ carry[i];
	end
	sum[4]		= carry[4];
end


// Group Generation
assign	gg = gen[3] | (gen[2] & prop[3]) | (gen[1] & prop[3] & prop[2]) | (gen[0] & prop[3] & prop[2] & prop[1] );

// Group Propration
assign	gp = &prop;

assign	f = (prop ^ gen) ^ (mode_i?4'b1111:carry[3:0]);
endmodule
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
