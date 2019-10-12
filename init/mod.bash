#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SMODTRPERROR_() { # Run on script error.
	local RV="$?"
	echo "$RV"
	printf "\\e[?25h\\n\\e[1;48;5;138mBuildAPKs mod.bash ERROR:  Generated script error %s near or at line number %s by \`%s\`!\\e[0m\\n" "${3:-UNDEFINED}" "${1:-LINENO}" "${2:-BASH_COMMAND}"
	exit 207
}

_SMODTRPEXIT_() { # run on exit
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit 0
}

_SMODTRPSIGNAL_() { # Run on signal.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Signal %s received!\\e[0m\\n" "mod.bash" "$RV"
 	exit 208 
}

_SMODTRPQUIT_() { # Run on quit.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "mod.bash" "$RV"
 	exit 209 
}

trap '_SMODTRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SMODTRPEXIT_ EXIT
trap _SMODTRPSIGNAL_ HUP INT TERM 
trap _SMODTRPQUIT_ QUIT 

_PRINTUMODS_() {
	printf "\\e[1;1;38;5;190m%s%s\\e[0m\\n\\n" "Updating buildAPKs:  \`${0##*/}\` might want to load sources from submodule repositories into buildAPKs.  This may take a little while to complete.  Please be patient if this script wants to download source code from https://github.com:" 
}

_PRINTNMODS_() { 
	printf "\\e[1;7;38;5;100m%s%s\\e[0m\\n" "To update module ~/${RDR##*/}/sources/$JID to the newest version remove the ~/${RDR##*/}/sources/$JID/.git file and run ${0##*/} again." 
}

_UMODS_() { 
	printf "\\e[1;1;38;5;191m%s\\e[0m\\n" "Updating module ~/${RDR##*/}/sources/$JID to the newest version... " 
	if grep -w $JID .gitmodules 1>/dev/null
	then
		(git submodule update --init --recursive --remote sources/$JID && _IAR_ "$RDR/sources/$JID") || (printf "\\n\\n\\e[1;1;38;5;190m%s%s\\e[0m\\n" "CANNOT UPDATE ~/${RDR##*/}/sources/$JID:  Continuing...") # https://www.tecmint.com/chaining-operators-in-linux-with-practical-examples/
	if [[ -f "$JDR"/ma.bash ]] 
	then 
		. "$RDR"/scripts/bash/shlibs/buildAPKs/at.bash 
		. "$JDR"/ma.bash 
	fi
	else
		(git submodule add https://$JAD sources/$JID && git submodule update --init --recursive --remote sources/$JID && _IAR_ "$RDR/sources/$JID" ) || (printf "\\n\\n\\e[1;1;38;5;190m%s%s\\e[0m\\n" "CANNOT ADD ~/${RDR##*/}/sources/$JID:  Continuing...") 
	fi
	if [[ -f "$JDR"/ma.bash ]] 
	then 
		. "$RDR"/scripts/bash/shlibs/buildAPKs/at.bash 
		. "$JDR"/ma.bash 
	fi
}

if [[ ! -d "$RDR"/cache/tarballs ]]
then
	mkdir -p "$RDR"/cache/tarballs
fi
export DAY="$(date +%Y%m%d)"
export NUM="$(date +%s)"
export JDR="$RDR/sources/$JID"
. "$RDR"/scripts/bash/shlibs/lock.bash 
. "$RDR"/scripts/bash/shlibs/buildAPKs/bnchn.bash bch.st 
. "$RDR"/scripts/bash/shlibs/buildAPKs/build.andm.bash 
if [[ -f "$JDR/.git" ]] # file exists in job directory
then # print modules message
	_PRINTNMODS_
else # print updating modules message
	_PRINTUMODS_
	_UMODS_
fi
_ANDB_ "$JDR"
. "$RDR"/scripts/bash/shlibs/buildAPKs/tots.bash
. "$RDR"/scripts/bash/shlibs/buildAPKs/bnchn.bash bch.gt 
# mod.bash EOF
