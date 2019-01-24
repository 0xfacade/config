#!/bin/bash

#i3lock -n -i ~/projects/config/xp.png -p win -u

# The crashed windows xp login.
# -i: background image
# -p: display windows style pointer
# -u: hide unlock indicator
# args="-i /home/ocius/projects/config/xp.png -p win -u"

args="-i /home/ocius/media/wallpapers/nebula2.png"

if [ "$1" = "nofork" ]; then
	args="$args -n"
fi

i3lock $args

