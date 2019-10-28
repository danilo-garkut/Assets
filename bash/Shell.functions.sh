#!/bin/bash

function CharToHex()
{
	local key=$1
	local hexkey=""
	for (( i=0; i<${#key}; i++ ))
	do
		local each_hex=$(echo -en ${key:$i:1} | hexdump -e '"%02X"')
		local save_key="$hexkey$each_hex"
		hexkey=$save_key
	done
	echo $hexkey
}


#Pad "this"($1), with p($2), if empty then perform PKCS#7 or 5 using the block size($4), left(0) or right(1)($3) pad, block size($4)
#Be aware that, if PKCS## chooses the byte 0x08, some content may be invisible as 0x08 is the BackSpace Byte :)
function Pad()
{
	local padded="$1"
	local padded_length=$(echo -en "${padded}" | wc -c)
	local remainder=$(( $padded_length % $4 ))
	local holder=""
	local side=$(test $3 && echo $3 || echo 1)
	local upto=$(( $4 - $remainder ))
#	local padwith=$( ! test -z $2 && echo -en $2 || echo -en "\x"$upto)
	

	if [ ${#upto} -gt 9 ]
	then
		local padwith=$( echo -n $upto )
	else
		local padwith=$( echo -n "0$upto" )
	fi
	
	DebugToStdError "Receiving to Pad($( echo -en "$1" | wc -c )):With($padwith) $1"

	! test -z $2 && padwith=$( echo -en $2 )


	for (( i=0; i < $upto; i++ ))
	do
		if [ $side -eq 0 ]
		then
			holder="$padwith$padded"
		else
			holder="$padded$padwith"
		fi
		padded="$holder"
	done
	padded_length=$(echo -en "${padded}" | wc -c)
	DebugToStdError "Response, $padded_length, $padded"
	echo -en "$padded"
}

#This is to log a Debug, without interceding in the main flow
function DebugToStdError
{
	echo -e ${@} 1>&2
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
function CurlFromFile()
{
	DebugToStdError "key:$1,\nto this url:$3,\nwith this post:$2\n"
	cat<<-HELLO

			curl 
			--request POST
			--data-urlencode ${1}@${2}
			--url $3

	HELLO
}

function Curl
{
	DebugToStdError "to this url:$2,\nwith this post:$1\n"
	cat<<-HELLO

			curl 
			--request POST
			--data-urlencode ${1}
			--url $2

	HELLO
}



