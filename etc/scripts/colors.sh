#!/bin/bash

#count=0

for i in {0..255}; do
	printf "\x1b[38;5;${i}mcolour${i}\x1b[0m "
	#count=$((${count}+${#i}+7)) # 7 = "colour" + " "
done
