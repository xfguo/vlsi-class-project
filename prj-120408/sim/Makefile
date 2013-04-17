VLOG_INC=+incdir+../include

all: test_full_adder test_dff test_counter
	
test_%: prepare
	vsim -c -do 'run;quit' tb_$(subst test_,,$@)

prepare:
	vlib work
	vlog $(VLOG_INC) ../rtl/verilog/counter.v 
	vlog $(VLOG_INC) ../rtl/verilog/dff.v	
	vlog $(VLOG_INC) ../rtl/verilog/full_adder.v
	vlog $(VLOG_INC) ../bench/tb_counter.v 
	vlog $(VLOG_INC) ../bench/tb_dff.v	
	vlog $(VLOG_INC) ../bench/tb_full_adder.v


clean:
	rm -rf work transcript
