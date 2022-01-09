#!/bin/bash

INITIAL_PARAMS="$#"
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`

help_me () {
    printf "Usage:- ./key_searcher <domain_url> \n"
    exit 2
}

arg_checker() {
    if [[ ${INITIAL_PARAMS} -ne 1 ]]; then 
        help_me
    fi
}

banner () {
    echo '    __ __              _____                      __             
   / //_/__  __  __   / ___/___  ____ ___________/ /_  ___  _____
  / ,< / _ \/ / / /   \__ \/ _ \/ __ `/ ___/ ___/ __ \/ _ \/ ___/
 / /| /  __/ /_/ /   ___/ /  __/ /_/ / /  / /__/ / / /  __/ /    
/_/ |_\___/\__, /   /____/\___/\__,_/_/   \___/_/ /_/\___/_/     
          /____/                                                 '

        echo 
        echo '     ------ By Gam -------     '
}

banner
echo 
arg_checker

target=$1

results=($(curl -s "https://web.archive.org/cdx/search/cdx?url=${target}*&output=text&fl=original&collapse=urlkey" | egrep -w 'key|apikey|apiKey|api-key|api_key|access-key|access_key'))
#results=($(curl -s "https://web.archive.org/cdx/search/cdx?url=${target}*&output=text&fl=original&collapse=urlkey"))

[ ${#results[@]} -eq 0 ] && echo "${RED}No results found ${RESET}"

for url in "${results[@]}" 
do
    sleep 2
    code=$(curl -s -o /dev/null -w "%{http_code}" ${url})
    if [[ $code -eq 200 ]]; then
        echo -e "$url ${GREEN}Valid ${RESET} ✅"
    fi
done

