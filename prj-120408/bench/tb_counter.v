`include "timescale.v"
module tb_counter;
parameter WIDTH = 8;

reg			clk_i;
reg			rst_i;
reg			clr_i;
reg			en_i;
reg			we_i;
reg	[WIDTH - 1:0]	dat_i;
wire	[WIDTH - 1:0]	dat_o;

counter uut (
	.clk_i ( clk_i ),
	.rst_i ( rst_i ),
	.clr_i ( clr_i ),
	.en_i  ( en_i ),
	.we_i  ( we_i ),
	.dat_i ( dat_i ),
	.dat_o ( dat_o )
);

parameter PERIOD = 10;

initial begin
//	$fsdbDumpfile("db_tb_counter.fsdb");
//	$fsdbDumpvars(0, tb_counter);
	clk_i = 1'b0;
	#(PERIOD/2);
	forever
		#(PERIOD/2) clk_i = ~clk_i;
end

initial begin
	#1000;
	$display("=====================================================");
	$display("TEST COUNTER");
	$display("-----------------------------------------------------");
	$finish;
end
endmodule
