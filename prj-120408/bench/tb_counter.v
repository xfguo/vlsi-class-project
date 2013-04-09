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
	clk_i = 1'b0;
	#(PERIOD/2);
	forever
		#(PERIOD/2) clk_i = ~clk_i;
end
integer i;
initial begin
	#98;
	$display("=====================================================");
	$display("TEST COUNTER");
	$display("-----------------------------------------------------");
	rst_i = 1;
	clr_i = 0;
	@(posedge clk_i);
	@(posedge clk_i);
	$display("Reset Test %s", (dat_o == 8'd0) ? "PASS":"FAIL");
	rst_i = 0;

	@(negedge clk_i);
	we_i = 1;
	en_i = 0;
	dat_i = 8'ha5;
	@(negedge clk_i);
	$display("Set Counter Test %s", (dat_o == 8'ha5) ? "PASS":"FAIL");
	@(negedge clk_i);
	we_i = 0;
	en_i = 0;
	@(negedge clk_i);
	en_i = 1;
	@(negedge clk_i);
	$display("Simple Count Test %s", (dat_o == 8'ha6) ? "PASS":"FAIL");
	for(i = 0;i < 256 + 12;i=i+1) begin
		@(negedge clk_i);
	end
	en_i = 0;
	$display("Over Count Test %s", (dat_o == (8'ha6 + 8'd12)) ? "PASS":"FAIL");

	for(i = 0;i < 256 + 12;i=i+1) begin
		@(negedge clk_i);
	end

	$display("Stop Count Test %s", (dat_o == (8'ha6 + 8'd12)) ? "PASS":"FAIL");
	
	@(negedge clk_i);
	clr_i = 1;
	@(negedge clk_i);
	$display("Clear Counter Test %s", (dat_o == 0) ? "PASS":"FAIL");
	$display("-----------------------------------------------------");
	$finish;
end
endmodule
