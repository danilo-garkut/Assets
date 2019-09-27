#!/bin/bash

#######################################

crypt_this=$(Pad "{\"a\":\"Hello\", \"login\":\"Cloud\", \"password\":\"Aeris\"}" "PKCS#5")
key=$(Pad "SecretKey" 0 0 32)
iv=$(Pad "0A0908FC" 0 0 32)
url="https://reach.this_url.com"

#######################################
