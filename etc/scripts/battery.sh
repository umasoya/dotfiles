#!/bin/zsh
# battery.sh 

# Checking whether AC adapter are connected
	is_charging=`pmset -g ps | awk 'NR==2{print $3}'`
# Get battery level
	parcentage=`pmset -g ps |awk 'NR==2{print $2}' | awk 'BEGIN{FS="%;";}{print $1}'` 

# If AC adapter are connected, color is Yellow
if [ "${is_charging}" != "discharging;" ]; then
	# If charging, font colour is yellow
	fgcolour="#[fg=colour226]"
	emoji="\U1F50C"
else
	emoji="\U1F50B"

	# 100% Blue
	if [ "${parcentage}" -eq "100" ]; then 
		fgcolour='#[fg=colour51]'
	
	# 31% ~ 99% Green
	elif [ "${parcentage}" -gt "30" ] && [ "${parcentage}" -lt "100" ]; then
		fgcolour="#[fg=colour46]"
	
	# 1% ~ 30% Red
	elif [ "${parcentage}" -le "30" ]; then
		fgcolour="#[fg=colour197]"
	fi

fi

echo -e ${emoji} ${fgcolour}${parcentage}'%#[default]'
