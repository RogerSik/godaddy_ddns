#!/bin/bash

# This script is used to check and update your GoDaddy DNS server to the IP address of your current internet connection.
# Special thanks to mfox for his ps script
# https://github.com/markafox/GoDaddy_Powershell_DDNS
#
# First go to GoDaddy developer site to create a developer account and get your key and secret
#
# https://developer.godaddy.com/getstarted
# Be aware that there are 2 types of key and secret - one for the test server and one for the production server
# Get a key and secret for the production server
#
#Update the first 4 variables with your information

domain=""   # your domain
name=""     # name of AAAA record to update
key=""      # key for godaddy developer API
secret=""   # secret for godaddy developer API

headers="Authorization: sso-key $key:$secret"

# echo $headers

result=$(curl -s -X GET -H "$headers" \
 "https://api.godaddy.com/v1/domains/$domain/records/AAAA/$name")

dnsIp=$(echo $result | grep -Eo "2[0-9a-fA-F]{3}:(([0-9a-fA-F]{1,4}[:]{1,2}){1,6}[0-9a-fA-F]{1,4})")
echo "dnsIp:" $dnsIp

# Get public ip address there are several websites that can do this.
currentIp=$(curl -s GET "https://ipv6.wtfismyip.com/text")
echo "currentIp:" $currentIp

if [ $dnsIp != $currentIp ];
 then
	# echo "Ips are not equal" # debug
	request='[{"data":"'$currentIp'","name":"'$name'","ttl":600,"type":"AAAA"}]'
	# echo $request # debug
	result=$(curl -i -s -X PUT \
 -H "$headers" \
 -H "Content-Type: application/json" \
 -d $request "https://api.godaddy.com/v1/domains/$domain/records/AAAA/$name")
	echo $nresult
fi
