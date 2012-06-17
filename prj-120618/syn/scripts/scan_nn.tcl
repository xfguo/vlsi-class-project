
#set environment
source ./scripts/setup.tcl

#read netlist file and get ready for inserting scan chain
read_file -format verilog {{./netlist/with_scanCell_detect.v}} 

current_design detect
proc make_test_ready {top_design}  {
set all_designs [get_designs]
  foreach_in_collection this_design $all_designs {
   current_design $this_design
   set_scan_state test_ready
   }
 current_design $top_design
 set_scan_state test_ready
}
set DESIGN detect 
current_design  $DESIGN 
make_test_ready $DESIGN 
current_design $DESIGN 
source -e ./scripts/cons.tcl
link
#configure scan ports
current_design $DESIGN 
set_dft_signal -view existing_dft -type ScanClock -timing [list 45.00 55.00 ] -port [get_port clk_i]
	# -period option(s) are not supported (Line 32 of script scan.tcl: create_test_clock command)
set_ideal_network [get_port clk_i]
set test_default_scan_style   multiplexed_flip_flop
set_scan_configuration -chain_count 1
set_scan_configuration -add_lockup true
set_scan_configuration -clock_mixing no_mix
set_dft_signal -view existing_dft -type Constant -active_state 1 -port scan_mode
set_dft_signal -port scan_mode -view spec -type TestMode -active_state 1
set_testability_configuration -type observe -clock_signal clk_i
#by pillar set_testability_configuration -type control -clock_signal clk_i -view spec 
set_testability_configuration -type control -clock_signal clk_i 
#set_signal_type   test_asynch_inverted reset_a_i 
set_dft_signal -view existing_dft -port reset_a_i -type Reset -active_state 1
set_dft_signal -view spec -port scan_en -type ScanEnable -active_state 1

set_scan_path path0 -view spec -dedicated_scan_out false 
set_dft_signal -view spec -port cap_1_1_i -type ScanDataIn
#set_scan_path path0 -view spec -complete false -scan_data_in cap_1_1_i 
set_dft_signal -view spec -port total_cap_o[0] -type ScanDataOut
set_scan_path path0 -view spec -complete false -scan_data_out total_cap_o[0] 
#check the design rule of test and start to insert scan chain
create_test_protocol
dft_drc -verbose
preview_dft -show all
current_design detect 
insert_dft
#creat test protocol to estimate test coverate 
#set test_stil_netlist_format verilog
#create_test_protocol -infer_asynch -infer_clock
dft_drc
estimate_test_coverage
write_test_protocol -out ./netlist/detect_scan.spf
	# -format option(s) are not supported (Line 59 of script scan.tcl: write_test_protocol command)
write -out "./netlist/with_scanchain_detect.v"  -form verilog  -hier  
write_sdf -version 1.0 ./sdf/core_with_scanchain_sdf_1p0.sdf -significant_digits 5
preview_dft -show scan_summary
quit

