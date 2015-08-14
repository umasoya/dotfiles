#!/usr/local/bin/zsh

# Get SSID Name
#networksetup -getairportnetwork en0 | awk '{print $4}'
networksetup -getairportnetwork en0 | awk '{print $4}'
