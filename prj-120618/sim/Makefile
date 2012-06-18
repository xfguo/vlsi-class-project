
VCS_DEBUSSY_ARGS=-P ${NOVAS_HOME}/share/PLI/vcs_latest/LINUX/novas.tab ${NOVAS_HOME}/share/PLI/vcs_latest/LINUX/pli.a

all: gen_pattern
	vcs \
		+v2k\
		-sverilog \
		-f filelist.vcs \
		${VCS_DEBUSSY_ARGS}
	env LD_LIBRARY_PATH=/eda/novas/novas-201010/share/PLI/vcs_latest/LINUX64 ./simv -l sim.log

postsim: gen_pattern
	make -C ../syn
	vcs \
		+v2k\
		-sverilog \
		-f filelist.post.vcs \
		${VCS_DEBUSSY_ARGS}
	env LD_LIBRARY_PATH=/eda/novas/novas-201010/share/PLI/vcs_latest/LINUX64 ./simv -l sim.log
	

dbu:
	debussy -2001 -sverilog -f filelist.vcs &

postdbu:
	debussy -2001 -sverilog -f filelist.post.vcs &

gen_pattern:
	python pattern_gen.py > test_pattern.v

clean:
	rm -rf simv csrc simv.daidir *.fsdb ucli.key debussyLog novas.rc novas_dump.log test_pattern.v sim.log
