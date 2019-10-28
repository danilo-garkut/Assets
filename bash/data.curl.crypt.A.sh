#!/bin/bash


#Sample data to crypt and post


#######################################

crypt_this=$(Pad "{\"a\":\"Hello\", \"login\":\"Cloud\", \"password\":\"Aeris\"}" "PKCS#5") #Multiple of 8 bytes
key=$(Pad "SecretKey" 0 0 32) #32Bytes
iv=$(Pad "" 0 1 32) #32Bytes
url="https://reach.this_url.com"
data_pack_name="data"

#######################################
