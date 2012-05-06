`include "timescale.v"
module tb_full_adder;
parameter WIDTH = 8;
reg	[WIDTH - 1:0]	a_i;
reg	[WIDTH - 1:0]	b_i;
reg			cy_i;
wire	[WIDTH - 1:0]	y_o;
wire			cy_o;

full_adder uut (
	.a_i  ( a_i ),
	.b_i  ( b_i ),
	.cy_i ( cy_i ),
	.y_o  ( y_o ),
	.cy_o ( cy_o )
);

initial begin
	$fsdbDumpfile("db_tb_full_adder.fsdb");
	$fsdbDumpvars;
	$display("=====================================================");
	$display("TEST FULL ADDER");
	$display("-----------------------------------------------------");
	// --------------------------------------------------------------------
	#1;
	a_i = 0;
	b_i = 0;
	cy_i = 0;
	#1;
	$display("%d + %d + (CY:%d) = %d (CY:%d) | %s", a_i, b_i, cy_i, y_o, cy_o, (cy_o == 0 && y_o == 0)?"PASS":"FAIL");
	// --------------------------------------------------------------------
	#1;
	a_i = 1;
	b_i = 1;
	cy_i = 1;
	#1;
	$display("%d + %d + (CY:%d) = %d (CY:%d) | %s", a_i, b_i, cy_i, y_o, cy_o, (cy_o == 0 && y_o == 3)?"PASS":"FAIL");
	// --------------------------------------------------------------------
	#1;
	a_i = 255;
	b_i = 255;
	cy_i = 1;
	#1;
	$display("%d + %d + (CY:%d) = %d (CY:%d) | %s", a_i, b_i, cy_i, y_o, cy_o, (cy_o == 1 && y_o == 255)?"PASS":"FAIL");
	// --------------------------------------------------------------------
	#1;
	a_i = 0;
	b_i = 255;
	cy_i = 0;
	#1;
	$display("%d + %d + (CY:%d) = %d (CY:%d) | %s", a_i, b_i, cy_i, y_o, cy_o, (cy_o == 0 && y_o == 255)?"PASS":"FAIL");
	// --------------------------------------------------------------------
	#1;
	a_i = 255;
	b_i = 0;
	cy_i = 1;
	#1;
	$display("%d + %d + (CY:%d) = %d (CY:%d) | %s", a_i, b_i, cy_i, y_o, cy_o, (cy_o == 1 && y_o == 0)?"PASS":"FAIL");
	// --------------------------------------------------------------------
	#1;
	a_i = 100;
	b_i = 155;
	cy_i = 1;
	#1;
	$display("%d + %d + (CY:%d) = %d (CY:%d) | %s", a_i, b_i, cy_i, y_o, cy_o, (cy_o == 1 && y_o == 0)?"PASS":"FAIL");
//	$finish;
	$fsdbDumpFinish;
end

endmodule
