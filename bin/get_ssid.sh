#!/usr/local/bin/zsh

# Get SSID Name
#networksetup -getairportnetwork en0 | awk '{print $4}'
SSID=`networksetup -getairportnetwork en0 | awk '{print $4}'`
#echo 'SSID:'$SSID

if [ $SSID=associated ];then
	echo OFFLINE
	exit 0
fi
