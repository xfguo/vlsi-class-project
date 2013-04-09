
test_%:
	fuse \
		-prj filelist.fuse.prj \
		-i ../include \
		-top tb_$(subst test_,,$@) \
		-o $@.exe
	./$@.exe -tclbatch fuse.cmd
all: test_full_adder test_dff test_counter

clean:
	rm -rf isim *.exe *.log fuseRelaunch.cmd *.xmsgs *.wdb
