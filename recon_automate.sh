#!/bin/bash

#This script automates most of the the repetitve stuff I've encountered while doing recon


bash_profile="${HOME}/.bash_profile"
source $bash_profile

domain=$1
mkdir $domain

#subdomain enumeration!
subdomainbruteforce(){
	assetfinder --subs-only $domain | httprobe -c 100 | tee -a "${domain}/${domain}-bruteforce.txt"
}

#content discovery!
 dirsearch(){
	cd $domain
	#will need sudo here (:-, i need to change the ownership of the reports folder soon!
	cat "${domain}-bruteforce.txt" | while read line;do python3 "${HOME}/tools/dirsearch/dirsearch.py" -e html,php,asp,aspx,log,txt,json -u $line -t 20;done
}

#always take screenshots!
 screenshot(){
	#lets store aquatone reports here
	cd $domain
	mkdir "${domain}-aquatone" && cd "${domain}-aquatone"
	AQUATONE_SCRIPT="${HOME}/tools/Aquatone/aquatone"

	cat "../${domain}-bruteforce.txt" | ${AQUATONE_SCRIPT}
}

 waybackmachine(){
	#fetch older urls/endpoints
	cd $domain
	cat $domain | waybackurls | tee -a "${domain}-waybackurls.txt"
}

 main(){
	subdomainbruteforce
	waybackmachine
	dirsearch
	screenshot
}

main

