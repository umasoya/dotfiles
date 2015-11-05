#!/usr/local/bin/zsh

# Get SSID Name
# ▁ ▃ ▇
# RSL(received signal level)


# Get SSID
SSID=`networksetup -getairportnetwork en0 | awk '{print $4}'`

# Get and Check RSSI
RSSI=`airport -I | awk 'NR==1{print $2}'`


echo "#[fg=white]${SSID}#[default]"
