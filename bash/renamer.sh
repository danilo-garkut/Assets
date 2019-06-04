#!/bin/bash

#Usage: 
#	find . -iregex '.*rule.*' | xargs -I{} ./batch_renamer.sh "{}" [notdryrun]
#	find . -iregex '.*rule.*' -exec ./batch_renamer.sh "{}" [notdryrun]
#Dryrun is the default
#Becareful with double+ matches

match=(config espelho humor marcac stat notifica) #from
intent=(configs mirror mood register status notifications) #to
without='@!$#^%&^'
prefix="greenish_"
sufix=".svg"

a="$1"
c=0

if [ "$2" = "notdryrun"  ]; then
	dryrun=0
#	echo "It will actually move the files"
#else
#	echo "Its a dryrun"
fi

for i in ${match[@]}
do
	matched=$(echo $a | grep -oi $i | grep -v $without)
#	echo "To match, $i, against $a"
	[ -n "$matched" ] &&
	{
		target=$prefix${intent[$c]}$sufix
		echo matched $matched against $a, moving $a to $target
	   	if [ $dryrun ]
		then	
			mv "$a" $target
		fi
	}
	((c++))
done


