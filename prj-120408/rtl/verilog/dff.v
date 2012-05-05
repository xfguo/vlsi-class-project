`include "timescale.v"
module dff(
	clk_i,

	rst_i,
	set_i,
	
	d_i,
	q_o
);
parameter WIDTH = 1;
input			clk_i;
input			rst_i;
input			set_i;

input	[WIDTH - 1:0]	d_i;
output	[WIDTH - 1:0]	q_o;

reg	[WIDTH - 1:0]	dff_r;
always @(posedge clk_i or posedge rst_i or posedge set_i) begin
	if(rst_i)
		dff_r <= {WIDTH{1'b0}};
	else if(set_i)
		dff_r <= {WIDTH{1'b1}};
	else
		dff_r <= d_i;
end

assign q_o = dff_r;
endmodule
