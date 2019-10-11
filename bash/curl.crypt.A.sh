#!/bin/bash

source Shell.functions.sh

#Personal data
#source data.curl.crypt.A.sh
source  ../../MyStuff/BashScripts/mine.data.curl.crypt.sh


IN=/tmp/in.curl.crypt
OUT=/tmp/out.curl.crypt

#This is the crypted to base64 decoded
IN2=/tmp/in2.curl.crypt

#Binary to plain
OUT2=/tmp/out2.curl.crypt

hexkey=$(CharToHex $key)

# A crypts
function A
{
	echo -en $crypt_this > $IN
	echo "Crypting: $crypt_this, length of ${#crypt_this}"
	Encrypt $IN $OUT $hexkey $iv
	echo "Hexkey from $key: $hexkey"
	post="$data_pack_name=$(cat $OUT)"
	echo "$post"
}

function B
{
	$(Curl $post $url) > $IN2
}

# C decrypts
function C
{
	echo "Decrypting: $(cat $IN2)"
	Base64Decode $IN2 $OUT2
	echo 
	Decrypt $hexkey $iv $OUT2
}


A
#B
#C





