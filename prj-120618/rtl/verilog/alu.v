module alu_74_181(
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

endmodule
