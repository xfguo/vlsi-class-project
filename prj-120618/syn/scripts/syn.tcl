file mkdir work
define_design_lib DEFAULT -path work
file mkdir ./elab/db

set DESIGN alu 
source -e ./scripts/setup.tcl

read_file -format verilog {{../rtl/verilog/alu.v}}

#set_dont_touch {SCAN_EN_I}

current_design $DESIGN 

#source -e ./scripts/cons.tcl

compile -scan
 
#compile  


##------------------------------------------------##
##              Naming Convention               --##
##              Single bit bus                  --##
##------------------------------------------------##
set bus_naming_style            "%s_%d_"

set bus_naming_style            "%s\[%d\]"
set hdlout_internal_busses      "false"
set verilogout_single_bit  "false"
set verilogout_equation  "false"
set verilogout_no_tri  "true"
set verilogout_show_unconnected_pins "true"

define_name_rules -equal_ports_nets -inout_ports_equal_nets verilog
change_names -rules verilog -hierarchy


write -format verilog -hier -out ./netlist/with_scanCell_$DESIGN.v
write -format ddc     -hier -out ./netlist/with_scanCell_$DESIGN.ddc

write_sdf -version 1.0 ./sdf/core_with_scancell_sdf_1p0.sdf -significant_digits 5

check_design
report_area
report_constraint
report_timing
quit

