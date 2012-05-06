
VCS_DEBUSSY_ARGS=-P ${NOVAS_HOME}/share/PLI/vcs_latest/LINUX/novas.tab ${NOVAS_HOME}/share/PLI/vcs_latest/LINUX/pli.a

all:vcs
	env LD_LIBRARY_PATH=/eda/novas/novas-201010/share/PLI/vcs_latest/LINUX64 ./simv
vcs:
	vcs \
		+v2k\
		-f filelist.vcs \
		${VCS_DEBUSSY_ARGS}

dbu:
	debussy -2001 -f filelist.vcs &

clean:
	rm -rf simv csrc simv.daidir
