#!/bin/bash
################################################################################
# this file is subject to Licence
#Copyright (c) 2024, Acktarius
################################################################################

#declaration variables and functions
#trip
trip() {
kill -INT $$
}

#srcipt Directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
#cd ${SCRIPT_DIR}


#general Check
if [[ ! -f git_to_track.json ]]; then
trip
fi

#Check Zenity
if ! command -v zenity &> /dev/null; then
echo "zenity not install\nrun following command to install it\nsudo apt-get install zenity"
sleep 3
trip
fi

#check jq installed
if ! command -v jq &> /dev/null; then
echo -e "jq not install\nrun following command to install it\nsudo apt-get install jq"
sleep 3
trip
fi

#check git installed
if ! command -v git &> /dev/null; then
echo -e "git not install\nrun following command to install it\nsudo apt-get install git"
sleep 3
trip
fi

#get_last_tag
getLastTag() {
lastTag=$(git ls-remote --tags --sort="v:refname" ${1} | tail -n1 | cut -d "/" -f 3)   
if [[ ${lastTag} =~ ^[a-zA-Z] ]]; then
v=${lastTag:0:1}
lastTag=${lastTag#${v}}
fi
echo $lastTag
}

#quantity to track
q=$(jq '.git_to_track | length' < git_to_track.json)


#main
if [[ $q -lt 1 ]]; then
trip
fi
declare -a nameTag
declare -a memTag
declare -a lastTag
declare -a toUpdate

for ((i = 0 ; i < $q ; i++)); do
nameTag[$i]=$(jq --argjson key $i '.git_to_track[$key].name' git_to_track.json)
nameTag[$i]=${nameTag[$i]:1:-1}
urlToCheck=$(jq --argjson key $i '.git_to_track[$key].url' git_to_track.json)
urlToCheck=${urlToCheck:1:-1}
lastTag[$i]=$(getLastTag $urlToCheck)
#echo "${lastTag[$i]}"
memTag[$i]=$(jq --argjson key $i '.git_to_track[$key].tag' git_to_track.json)
memTag[$i]=${memTag[$i]:1:-1}
done

list() {
for ((i = 0 ; i < $q ; i++)); do
if [[ ${memTag[$i]} != ${lastTag[$i]} ]]; then
    state=$(echo -e "${lastTag[$i]}\n${memTag[$i]}" | sort -V | head -n 1)
    if [[ $state == ${memTag[$i]} ]]; then
    echo -e "FALSE $i ${nameTag[$i]} ${memTag[$i]} New_Release_since_last_check"
    fi
else
echo -e "FALSE $i ${nameTag[$i]} ${memTag[$i]} Nothing_new"
fi
done
}

updateTag() {
for j in ${toUpdate[@]}; do
tmp=$(mktemp)
jq --argjson key $j --arg value ${lastTag[$j]} '.git_to_track[$key].tag |= $value'  git_to_track.json > "$tmp" && cp "$tmp" git_to_track.json
done
}


addTag() {
newRepo=$(zenity --forms --title="Add new Github to track" --separator "|" --add-entry "name" --add-entry "url")
case $? in
    0)
        newRepoName=$(echo $newRepo | cut -d "|" -f 1)
        newRepoUrl=$(echo $newRepo | cut -d "|" -f 2)
        if [[ ${newRepoUrl:0:8} != "https://" ]] || [[ ${newRepoUrl:(-4)} != ".git" ]]; then
        exit
        fi
        already=$(jq --arg name $newRepoName '.git_to_track[] | select(.name == $name)' git_to_track.json | wc -l)
        if [[ $already -eq 0 ]]; then
        newRepoTag=$(getLastTag $newRepoUrl)
        tmp=$(mktemp)
        jq --arg name "$newRepoName" --arg url "$newRepoUrl" --arg tag "$newRepoTag" \
        '.git_to_track += [{"name": $name, "url": $url, "tag": $tag}]' git_to_track.json > "$tmp" && cp "$tmp" git_to_track.json
        if [[ $? -eq 0 ]]; then
        zenity --info --text="git to track added"
        fi
        fi
        ;;
    1)
        exit
	;;
    *)
    exit
	;;
esac
}

zenList=$(list)
update=$(zenity --list --checklist --height 320 --width 600 --title "Track your favorite github repo " --timeout 25 --extra-button Add --ok-label "Update" --column "Select" --column "index" --column "name" --column "tag" --column "status" $zenList)
toUpdate=($(echo $update | tr "|" " "))
if [[ $? -eq 0 ]]; then
    case "$toUpdate" in
        "Add")
        addTag
        ;;       
        "")
        exit
        ;;
        *)
        updateTag
        ;;
    esac    
fi
