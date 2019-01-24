#!/bin/bash

# A script to simplify the interface to nmcli.
# Possible commands:
# 	* list: list all available wifis
#	* connect SSID: connect to the wifi named by SSID.
# 		If the connection is unknown, interactively ask for the password.
#	* off: turn of wifi
#   * status (default): show connection status

function wifi_list {
	nmcli radio wifi on
	nmcli dev wifi list
}

function wifi_connect {
	nmcli radio wifi on	

	# if no connection name was specified, then simply turn on wifi
	# so that it might autoconnect
	if [ -z "$1" ]; then 
		echo "Turned on wifi - may autoconnect."	
		exit
	fi
	
	nmcli -t connection show | grep "$1:" > /dev/null

	if [ $? -eq 0 ]; then
		# The connection is known
		echo "Connecting to known connection $1."
		nmcli con up id "$1" > /dev/null
		exit
	fi

	echo "Creating new connection to wifi $1."
	
	# Get the list of currently available wifis.
	WIFIS=$(nmcli -t dev wifi list)

	# Check if the provided wifi is among those.
	echo "$WIFIS" | grep ":$1:" > /dev/null
	if [ $? -eq 1 ]; then
		echo "No WiFi with that SSID."
		exit 1
	fi

	nmcli dev wifi con "$1" name "$1" --ask
	exit

	# First, get the different security modes (multiple per line possible)
	SECURITY=$(echo "$WIFIS" | grep ":$1:" | awk -F ':' '{ print $8; }')
	# Get them unique, one on each line.
	SECURITY=$(echo -e "${SECURITY// /\\n}" | sort -u)
	# Join them back toegether.
	SECURITY=$(echo $(echo -e "${SECURITY// /\\n}"))

	if [[ $SECURITY == *"WPA"* ]]; then
		echo -n "Enter WPA password: "
		read -s PASSWORD
		echo
		nmcli dev wifi con "$1" password "$PASSWORD" name "$1"
	elif [ -z "$SECURITY" ]; then
		echo "Network has no security. Connecting without password."
		nmcli dev wifi con "$1" name "$1"
	else
		echo "Unknown security type: $SECURITY"
	fi
}

function wifi_off {
	if [ "$(nmcli -t radio wifi)" = "disabled" ]; then
		echo "Wifi already turned off."
	else
		nmcli radio wifi off
		echo "Wifi turned off."
	fi
}

if [ "$1" = "list" ]; then
	wifi_list
elif [ "$1" = "connect" ]; then
	wifi_connect $2
elif [ "$1" = "off" ]; then
	wifi_off	
else 
	nmcli general	
fi
