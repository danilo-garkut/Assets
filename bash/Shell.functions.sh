#!/bin/bash

function CharToHex()
{
	local key=$1
	local hexkey=""
	for (( i=0; i<${#key}; i++ ))
	do
		local each_hex=$(echo -en ${key:$i:1} | hexdump -e '"%X"')
		local save_key="$hexkey$each_hex"
		hexkey=$save_key
	done
	echo $hexkey
}


#Pad "this"($1), with p($2), left(0) or right(1)($3) pad, up to n($4)
#Also makes PKCS#5 if p is = "PKCS#5", which will make 
#n = 8, right pad and fill with the expected bytes as 16 bytes multiple
#Be aware that, if PKCS#5 chooses the byte 0x08, content may be invisible as 0x08 is the BackSpace Byte :)
function Pad()
{
	local padded=$1
	local holder=""
	local check_pkcs5="PKCS#5"
	local side=$(test $3 && echo $3 || echo 1)
	if [ $2 = $check_pkcs5 ]
	then
		local pkcs_bytes=8
		local pad_minimal=16
		local upto=$((pkcs_bytes - ($(echo -n ${padded} | wc -c) % 8) ))
		padwith=$(echo -en "\x0"$(( $upto )))
	else
		local upto=$(($4 - ($(echo -n ${padded} | wc -c) % $4) ))
		padwith=$(echo -en $2)
	fi

	for (( i=0; i < $upto; i++ ))
	do
		if [ $side -eq 0 ]
		then
			holder=$padwith$padded
		else
			holder=$padded$padwith
		fi
		padded=$holder
	done

	if [ ! -z $pad_minimal ]
	then

		(
			! test $(( ${#padded} % $pad_minimal )) -eq 0
		)
		multiple=$?
		if [ $multiple -eq 0 ]
		then
			DebugToStdError "Pad recurse: $padded(${#padded}), padded upto: $upto"
			Pad $padded $2 $3 $4
			return
		fi 
	fi

	DebugToStdError "Pad result: $padded(${#padded}), padded upto: $upto"

	echo -n $padded
}

#This is to log a Debug, without interceding in the main flow
function DebugToStdError
{
	echo ${@} 1>&2
}

function Encrypt()
{
	openssl enc -e -aes-256-cbc -nosalt -nopad -p -v -A -base64 -in $1 -out $2 -K $3 -iv $4
}

function Decrypt()
{
	openssl enc -d -aes-256-cbc -nosalt -p -v -K $1 -iv $2 -in $3
}

function Base64Decode()
{
	base64 --decode $1 > $2
	echo "Byte count after Base64 decode: $(cat $2 | wc -c)"
}

# $(Curl a=a https://a.com)
function Curl()
{
	cat<<-HELLO

			curl 
			--request POST
			--data-urlencode $1
			--url $2

	HELLO
}



