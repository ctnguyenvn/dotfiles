#!/bin/sh

B='#00000000' # blank
C='#ffffff22' # clear ish
D='#00897bE6' # default
T='#00897bee' # text
W='#880000bb' # wrong
V='#bb00bbbb' # verifying

/usr/bin/i3lock \
	--insidevercolor=$C \
	--ringvercolor=$V \
	\
	--insidewrongcolor=$C \
	--ringwrongcolor=$W \
	\
	--insidecolor=$B \
	--ringcolor=$D \
	--linecolor=$B \
	--separatorcolor=$D \
	\
	--verifcolor=$T \
	--wrongcolor=$T \
	--timecolor=$T \
	--datecolor=$T \
	--layoutcolor=$T \
	--keyhlcolor=$W \
	--bshlcolor=$W \
	\
	--screen 1 \
	--blur 5 \
	--clock \
	--indicator \
	--timestr="%H:%M:%S" \
	--datestr="%A, %m %Y" \
	--keylayout 1
