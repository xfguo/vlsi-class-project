`include "timescale.v"
module tb_dff;

parameter WIDTH = 8;

reg			clk_i;
reg			rst_i;
reg			set_i;
reg	[WIDTH - 1:0]	d_i;
wire	[WIDTH - 1:0]	q_o;

dff #(WIDTH) uut (
	.clk_i ( clk_i ),
	.rst_i ( rst_i ),
	.set_i ( set_i ),
	.d_i   ( d_i ),
	.q_o   ( q_o )
);

parameter PERIOD = 10;

initial begin
	$fsdbDumpfile("db_tb_dff.fsdb");
	$fsdbDumpvars;
	clk_i = 1'b0;
	#(PERIOD/2);
	forever
		#(PERIOD/2) clk_i = ~clk_i;
end

initial begin
	// Test Asynchronous Reset
	#13;
	$display("=====================================================");
	$display("TEST DFF");
	$display("-----------------------------------------------------");
	$display("%t:q_o = %08b", $time, q_o);
	rst_i = 1;
	#1;
	$display("%t:q_o = %08b", $time, q_o);
	$display("Test Asynchronous Reset:%s", q_o == 8'd0 ?"PASS":"FAIL");
	$display("-----------------------------------------------------");
	#1;
	$display("%t:q_o = %08b", $time, q_o);
	rst_i = 0;
	set_i = 1;
	#1;
	$display("%t:q_o = %08b", $time, q_o);
	$display("Test Asynchronous Set:%s", q_o == 8'hff ?"PASS":"FAIL");
	$display("-----------------------------------------------------");
	#1;
	rst_i = 0;
	set_i = 0;
	#1;
	@(negedge clk_i);
	d_i = 8'haa;
	$display("%t:q_o = %08b", $time, q_o);
	@(negedge clk_i);
	d_i = ~q_o;
	$display("%t:q_o = %08b", $time, q_o);
	@(negedge clk_i);
	$display("%t:q_o = %08b", $time, q_o);
	$display("Test Synchronous Input:%s", q_o == 8'h55 ?"PASS":"FAIL");

	$display("-----------------------------------------------------");
//	$finish;
end

endmodule
