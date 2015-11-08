#!/bin/bash

# Get SSID Name
# ▁ ▃ ▇
# RSL(received signal level)

# Enable aliases(bash only)
shopt -s expand_aliases
source ~/dotfiles/.bashrc

# Get SSID
SSID=`networksetup -getairportnetwork en0 | awk '{print $4}'`

# Get and Check RSSI
RSSI=`airport -I | awk 'NR==1{print $2}'`

if [ "${RSSI}" -ge "-49" ]; then
	RSL='▃ ▆ ▇'
elif [ "${RSSI}" -ge "-79" ] && [ "${RSSI}" -le "-50" ]; then
	RSL='▃ ▆  '
else
	RSL='▃    '
fi


echo "#[fg=colour231]${SSID} ${RSL}#[default]"
