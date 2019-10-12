#!/bin/env bash 
# Copyright 2019 (c) all rights reserved 
# by BuildAPKs https://buildapks.github.io/buildAPKs/
#####################################################################
set -eu
_ANDB_() {
	for APP in $(ls -d -1 "$1/"**/AndroidManifest.xml) # https://stackoverflow.com/questions/246215/how-can-i-generate-a-list-of-files-with-their-absolute-path-in-linux
	do 
		cd ${APP%/*} || (printf "\\e[1;7;38;5;220m%s\\e[0m\\n" "Unable to find the job directory:  Continuing...") # search: string manipulation site:www.tldp.org
		("$RDR/scripts/bash/build/build.one.bash"  ${APP%/*} 2>>"$RDR/log/stnderr.$JID.log") || (printf "\\e[1;7;38;5;220m%s\\e[0m\\n" "Unable to process jobs in the job directory:  Continuing...")
	done
}
# build.andm.bash EOF
