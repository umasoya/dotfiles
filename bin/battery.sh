#!/bin/zsh
# battery.sh 

# Checking whether AC adapter are connected
	power_source=`pmset -g ps | awk 'NR==2{print $3}'`
# Get battery level
	parcentage=`pmset -g ps |awk 'NR==2{print $2}' | awk 'BEGIN{FS="%;";}{print $1}'` 

#------------
# Rewrite
#------------

# If AC adapter are connected, color is Yellow
if [ "${power_source}" = "charging;" ]; then
	# If charging, font colour is yellow
	fgcolour="#[fg=colour226]"

# 100% Blue
elif [ "${parcentage}" -eq "100" ]; then 
	fgcolour='#[fg=colour51]'

# 31% ~ 99% Green
elif [ "${parcentage}" -gt "30" ] && [ "${parcentage}" -lt "100" ]; then
	fgcolour="#[fg=colour46]"

# 1% ~ 30% Red
elif [ "${parcentage}" -le "30" ]; then
	fgcolour="#[fg=colour197]"

fi

echo -e ${fgcolour}${parcentage}'%#[default]'

