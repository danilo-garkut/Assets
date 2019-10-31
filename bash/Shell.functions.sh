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
	DebugToStdError "HexResult: $hexkey"
	echo $hexkey
}

function SpacePad
{
	local padded="$1"
	local padded_length=$(echo -en "${padded}" | wc -c)
	local save_padded_length=$padded_length

	while test $(( $2 - ($padded_length % $2) )) -gt 8
	do
		local space_byte=$(echo -en "\x20");
		local current_padded="$padded"
		padded="${current_padded}${space_byte}"
		padded_length=$(echo -en "${padded}" | wc -c)
	done
	DebugToStdError "SpacePad: ${save_padded_length}->${padded_length}"
	echo -en "$padded"
}


#Pad "this"($1), with p($2), if empty then perform PKCS#7 or 5 using the block size($4), left(0) or right(1)($3) pad, block size($4)
#Be aware that, if PKCS## chooses the byte 0x08, some content may be invisible as 0x08 is the BackSpace Byte, or visible through hexdump :)
function Pad()
{
	local padded="$1"
	local padded_length=$(echo -en "${padded}" | wc -c)

	local remainder=$(( $padded_length % $4 ))
	local holder=""
	local side=$(test $3 && echo $3 || echo 1)
	local upto=$(( $4 - $remainder ))

	if [ ! -z $2  ]
	then
		local padwith=$( echo -en "$2" )
		local visible_padwith=$( echo -n "$2" )
	else
		local padwith=$( echo -en "\x$upto" )
		local visible_padwith=$( echo -n "\x$upto" )
	fi

	DebugToStdError "Receiving to Pad($padded_length):With($visible_padwith):Upto($upto) $1"

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
	crop=200
	DebugToStdError "Response length: $padded_length, potentially cropped content: ${padded:0:$crop}"
	echo -en "$padded"
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
	DebugToStdError "Decrypt arguments: $@"
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
	DebugToStdError $(echo -en "key:$1,\nto this url:$3,\nwith this post:$2\n")
	cat<<-HELLO

			curl 
			--request POST
			--data-urlencode ${1}@${2}
			--url $3

	HELLO
}

function Curl
{
	DebugToStdError $(echo -en "to this url:$2,\nwith this post:$1\n")
	cat<<-HELLO

			curl 
			--request POST
			--data-urlencode ${1}
			--url $2

	HELLO
}



