NOVAS_HOME=/eda/novas
#VCS_DEBUSSY_ARGS=-P ${NOVAS_HOME}/share/PLI/VCS/LINUX/novas.tab ${NOVAS_HOME}/share/PLI/VCS/LINUX/pli.a

all:vcs
	env LD_LIBRARY_PATH=/eda/novas/share/PLI/VCS/LINUX NOVAS_HOME=${NOVAS_HOME} ./simv
vcs:
	vcs \
		+v2k\
		-f filelist.vcs \
		${VCS_DEBUSSY_ARGS}

dbu:
	/usr/bin/i386 /eda/novas/bin/debussy -2001 -f filelist.vcs &

clean:
	rm -rf simv csrc simv.daidir
