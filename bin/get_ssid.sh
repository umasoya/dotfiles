#!/usr/local/bin/zsh

# Get SSID Name
# ▁▂▃▅▇
# RSL(received signal level)


# Get SSID
SSID=`networksetup -getairportnetwork en0 | awk '{print $4}'`

# Get and Check RSSI
RSSI=`airport -I | awk 'NR==1{print $2}'`

#if [ ${RSSI} -ge -39 ]; then
#	#reception is Excellent
#	echo Excellent
##	RSL="▁▂▃▅▇"
#else
#	if [ ${RSSI} -ge -49 ] && [ ${RSSI} -le 40 ]; then
#		#reception is Good
#		echo Good
##		RSL="▁▂▃▅"
#	else
#	if [ ${RSSI} -ge -59 ] && [ ${RSSI} -le 50 ]; then
#		#reception is average
#		echo average
##		RSL="▁▂▃"
#	else
#	if [ ${RSSI} -ge -79 ] && [ ${RSSI} -le 60 ]; then
#		#reception is fair
#		echo fair
##		RSL="▁▂"
#	else
#if [ ${RSSI} -le -80 ]; then
#	#reception is Poor
#	echo Poor
##	RSL="▁"
#fi



echo "#[fg=white]${SSID}#[default]"
