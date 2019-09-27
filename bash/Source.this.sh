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


#Pad "this", with p, left or right pad, up to n
#Also makes PKCS#5 if p is "PKCS#5", 
#will make n = 8 and right pad and fill with the expected bytes
function Pad()
{
	local padded=$1
	local holder=""
	local check_pkcs5="PKCS#5"
	local pkcs_bytes=8
	local side=$(test $3 && echo $3 || echo 1)
	if [ $2 = $check_pkcs5 ]
	then
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
	echo -n $padded
}


function Encrypt()
{
	openssl enc -e -aes-256-cbc -nosalt -nopad -p -v -A -base64 -in $1 -out $2 -K $3 -iv $4
	#-nopad \
}

function Decrypt()
{
	openssl enc -d -aes-256-cbc -nosalt -p -v -K $1 -iv $2 -in $3
}

function Base64Decode()
{
	base64 --decode $1 > $2
	echo "Byte count after Base64 decode: $(cat $2 | wc)"
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



