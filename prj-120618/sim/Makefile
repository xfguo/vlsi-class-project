
VCS_DEBUSSY_ARGS=-P ${NOVAS_HOME}/share/PLI/vcs_latest/LINUX/novas.tab ${NOVAS_HOME}/share/PLI/vcs_latest/LINUX/pli.a

all:
	vcs \
		+v2k\
		-sverilog \
		-f filelist.vcs \
		${VCS_DEBUSSY_ARGS}
	env LD_LIBRARY_PATH=/eda/novas/novas-201010/share/PLI/vcs_latest/LINUX64 ./simv

postsim:
	vcs \
		+v2k\
		-sverilog \
		-f filelist.post.vcs \
		${VCS_DEBUSSY_ARGS}
	env LD_LIBRARY_PATH=/eda/novas/novas-201010/share/PLI/vcs_latest/LINUX64 ./simv
	

dbu:
	debussy -2001 -sverilog -f filelist.vcs &

postdbu:
	debussy -2001 -sverilog -f filelist.post.vcs &

clean:
	rm -rf simv csrc simv.daidir *.fsdb ucli.key debussyLog novas.rc novas_dump.log
