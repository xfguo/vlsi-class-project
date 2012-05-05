`include "timescale.v"
module counter(
	clk_i,
	rst_i,

	clr_i,
	en_i,
	we_i,
	dat_i,

	dat_o
);
parameter WIDTH = 8;
input			clk_i;	
input			rst_i;	
input			clr_i;	
input			en_i;	
input			we_i;	
input	[WIDTH - 1:0]	dat_i;	
output	[WIDTH - 1:0]	dat_o;

reg	[WIDTH - 1:0]	cntr_dff_i;
wire	[WIDTH - 1:0]	cntr_dff_o;
wire	[WIDTH - 1:0]	full_adder_o;
reg	[WIDTH - 1:0]	dat_r;
/******************************************************************************
always @(posedge clk_i or posedge rst_i) begin
	if(rst_i)
		dat_r <= 0;
	else if(clr_i)
		dat_r <= 0;
	else if(we_i)
		dat_r <= dat_i;
	else if(en_i)
		dat_r <= dat_r + 1;
	else
		dat_r <= dat_r;
end
assign dat_o = dat_r;
******************************************************************************/
always @(*) begin
	if(clr_i)
		cntr_dff_i = {WIDTH{1'b0}};
	else if(we_i)
		cntr_dff_i = dat_i;
	else if(en_i)
		cntr_dff_i = full_adder_o;
	else
		cntr_dff_i = cntr_dff_o;
end

full_adder #(WIDTH) 
counter_full_adder  (
	.a_i	( cntr_dff_o	),
	.b_i	( {WIDTH{1'd0}}	),
	.cy_i	( 1'b1		),
	.y_o	( full_adder_o	),
	.cy_o	( 		)
);

dff #(WIDTH) 
counter_dff(
	.clk_i	( clk_i		),
	.rst_i	( rst_i		),
	.set_i	( 1'b0		),
	.d_i	( cntr_dff_i	),
	.q_o	( cntr_dff_o	)
);
assign dat_o = cntr_dff_o;
endmodule
