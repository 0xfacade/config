#!/bin/bash

if [ -z "$1" ]; then
	echo "First argument should be 'on' or 'off'"
	exit
fi

# Obtain this by running `xinput list` (look for your mouse inputs)
IDS="14 15"

function disable_inputs {
	for id in $IDS; do
		xinput set-prop $id "Device Enabled" 0
	done
}

function enable_inputs {
	for id in $IDS; do
		xinput set-prop $id "Device Enabled" 1
	done
}

if [ "$1" = "on" ]; then
	enable_inputs
else
	disable_inputs
fi
