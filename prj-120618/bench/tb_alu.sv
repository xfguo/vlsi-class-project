`include "timescale.v"
module tb_alu;

reg		mode_control_i;
reg	[3:0]	select_input_i;
reg	[3:0]	operand_a_i;
reg	[3:0]	operand_b_i;
reg		carry_input_i;
wire	[3:0]	function_output_o;
wire		generate_output_o;
wire		propagate_output_o;
wire		carry_output_o;
wire		cmp_output_o;

alu uut (
	.mode_control_i     ( mode_control_i 	),
	.select_input_i     ( select_input_i 	),
	.operand_a_i        ( operand_a_i 	),
	.operand_b_i        ( operand_b_i 	),
	.carry_input_i      ( carry_input_i 	),
	.function_output_o  ( function_output_o ),
	.generate_output_o  ( generate_output_o ),
	.propagate_output_o ( propagate_output_o),
	.carry_output_o     ( carry_output_o 	),
	.cmp_output_o       ( cmp_output_o	)
);

`ifdef POSTSIM
initial $sdf_annotate("../syn/sdf/core_with_scancell_sdf_1p0.sdf", uut);
`endif


task print_test_header;
	input [8*32-1:0] title;
	begin
		$display("----------------------------------------------");
		$display("%-s", title);
		$display("mode\tsel\ta\tb\t~ca_i\tf\tg\tp\t~ca_o\tcmp");
	end
endtask

task test_alu;
	input		m_i;
	input	[3:0]	sel_i;
	input	[3:0]	a_i;
	input	[3:0]	b_i;
	input		ci_i;

	input	[3:0]	f_i;
	input		g_i;
	input		p_i;
	input		co_i;
	input		cmp_i;
	begin
		#100;
		mode_control_i	= m_i;
                select_input_i	= sel_i;
                operand_a_i	= a_i;
                operand_b_i	= b_i;
		carry_input_i	= ci_i;
		#100;
		$display("%01x\t%04b\t%04x\t%04x\t%01b\t%04x\t%01b\t%01b\t%01b\t%01b\t%s", 
			mode_control_i, 
			select_input_i, 
			operand_a_i, 
			operand_b_i, 
			carry_input_i,
			function_output_o,
			generate_output_o,
			propagate_output_o,
			carry_output_o,
			cmp_output_o,
			(f_i[3:0] == function_output_o)?"PASS":"FAIL"
			);
	end
endtask
initial begin
	$fsdbDumpfile("db_tb_dff.fsdb");
	$fsdbDumpvars;
end
integer i;
integer a, b;
initial begin
`include "test_pattern.v"
	$finish;
end

endmodule
