#!/bin/bash

source Shell.functions.sh

test -z $1 &&\
	source data.curl.crypt.A.sh ||\
	source $1

IN=/tmp/in.curl.crypt
OUT=/tmp/out.curl.crypt

POST=/tmp/post

#This is the crypted to base64 decoded
IN2=/tmp/in2.curl.crypt

#Binary to plain
OUT2=/tmp/out2.curl.crypt

# A crypts
function A
{
	echo -n "$padded" > $IN
#	cat $IN | hexdump -v -e '1/1 "[%02X]"'
	Encrypt $IN $OUT $key $iv
	cat $OUT > $POST
#	post="$data_pack_name=$(cat $OUT)"
}

function B
{
	$(CurlFromFile "$data_pack_name" "$POST" $url) > $IN2
#	$(Curl  "$post" $url) > $IN2
}

# C decrypts
function C
{
	echo "Decrypting: $(cat $IN2)"
	Base64Decode $IN2 $OUT2
	echo 
	Decrypt $key $iv $OUT2
}


A
B
C



