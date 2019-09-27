#!/bin/bash


source data.curl.crypt
source Source.this.sh

IN=/tmp/in.curl.crypt
OUT=/tmp/out.curl.crypt

#This is the crypted to base64 decoded
IN2=/tmp/in2.curl.crypt

#Binary to plain
OUT2=/tmp/out2.curl.crypt

hexkey=$(CharToHex $key)

function CryptAndCurl()
{
	echo -en $crypt_this > $IN
	echo "Crypting: $crypt_this, length of ${#crypt_this}"
	Encrypt $IN $OUT $hexkey $iv
	echo "Hexkey from $key: $hexkey"
	post="dados=$(cat $OUT)"
	echo "Sending: $post"
	$(Curl $post $url) > $IN2
}

CryptAndCurl

echo "Imediate response: $(cat $IN2)"
Base64Decode $IN2 $OUT2
echo 
Decrypt $hexkey $iv $OUT2



