#!/bin/zsh
# 
# 2015.08.14
#
#
#

	source_power=`pmset -g ps | awk 'NR==1{print $4,$5}'`
	parcentage=`pmset -g ps |awk 'NR==2{print $2}' | awk 'BEGIN{FS="%;";}{print $1}'` 

# test echo
# echo '${source_power}:'${source_power}
# echo -e '${parcentage}:'"\e[36m ${parcentage}% \e[m"

if [ ${source_power}='AC Power' ]; then
	echo '#[fg=cyan]'${parcentage}%'#[default]'
	exit 0
fi

if [ ${parcentage} -gt 30 ]; then
	echo '#[fg=green]'${parcentage}%'#[default]'
else
	echo '#[fg=red]'${parcentage}%'#[default]'
fi
