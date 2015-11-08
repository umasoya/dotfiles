#!/bin/zsh
# battery.sh 

# Get battery level
	source_power=`pmset -g ps | awk 'NR==1{print $4,$5}'`
	parcentage=`pmset -g ps |awk 'NR==2{print $2}' | awk 'BEGIN{FS="%;";}{print $1}'` 

# 100% (AC Power) Blue
if [ "${parcentage}" -eq "100" ] || [ "${source_power}" = "AC Power" ]; then
	echo '#[fg=colour51]100%#[default]'
fi

# 31% ~ 99% Green
if [ "${parcentage}" -gt "30" ] && [ "${parcentage}" -lt "100" ]; then
	echo '#[fg=colour46]'${parcentage}'%#[default]'
fi

# 1% ~ 30% Red
if [ "${parcentage}" -le "30" ]; then
	echo -e '#[fg=colour197]'${parcentage}'%#[default]'
fi
