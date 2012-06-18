
set TIMING_COEF  0.8
set CLK_PD       10 
set_max_fanout 16 $DESIGN
set_max_transition 2 $DESIGN
set_max_capacitance 3 $DESIGN
set_max_area  4200

#set_driving_cell -lib_cell SVH_BUF_1 [ remove_from_collection [all_inputs] [get_ports glb_clk] ]

#set clk_name  glb_clk
#create_clock -p  [expr $CLK_PD*$TIMING_COEF] -n  $clk_name [get_ports glb_clk] 
#set_dont_touch_network [get_clocks $clk_name]
#set_clock_uncertainty 0.1 $clk_name 
#set_clock_transition 0.1 $clk_name

#set_output_delay   0.2  -max -clock  $clk_name [all_outputs]  
#set_output_delay   0.1  -min -clock  $clk_name [all_outputs]  
#set_input_delay    0.1  -max -clock  $clk_name [all_inputs]  
#set_input_delay    0.2 -min -clock  $clk_name [all_inputs]  


