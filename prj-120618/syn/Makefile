#! /bin/bash

all:
	rm -rf ./log/*.log
	dc_shell-t -f ./scripts/syn.tcl | tee -a ./log/syn.log

clean:
	rm -rf ./log/* ./sdf/* command.log default.svf ./netlist/* 
 
