#!/bin/env bash
# Copyright 2019 (c) all rights reserved
# by BuildAPKs https://buildapks.github.io/buildAPKs/
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SPREPTRPERROR_() { # run on script error
	local RV="$?"
	echo "$RV" prep.bash
	printf "\\e[?25h\\n\\e[1;48;5;138mBuildAPKs %s ERROR:  Generated script error %s near or at line number %s by \`%s\`!\\e[0m\\n" "${PWD##*/}" "${1:-UNDEF}" "${2:-LINENO}" "${3:-BASH_COMMAND}"
	exit 144
}

_SPREPTRPEXIT_() { # run on exit
	printf "\\e[?25h\\n\\e[1;48;5;112mBuildAPKs %s\\e[0m\\n" "${0##*/}: DONE!"
	set +Eeuo pipefail
	exit
}

_SPREPTRPSIGNAL_() { # run on signal
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Signal %s received!\\e[0m\\n" "prep.bash" "$RV"
 	exit 145
}

_SPREPTRPQUIT_() { # run on quit
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "prep.bash" "$RV"
 	exit 146
}

trap '_SPREPTRPERROR_ $? $LINENO $BASH_COMMAND' ERR
trap _SPREPTRPEXIT_ EXIT
trap _SPREPTRPSIGNAL_ HUP INT TERM
trap _SPREPTRPQUIT_ QUIT

_IAR_ () { 
	if [[ -z "${SFX:-}" ]]
	then
		SFX=""
	fi
	if [[ -z "${WDIR:-}" ]]
	then
		WDIR="$JDR/$SFX"
	fi
	_AFR_ || printf "%s prep.bash WARNING: Could not process _AFR_; Continuing...\\n" "${0##*/}"
}

_AFR_ () { # finds and removes superfluous directories and files
	if [[ -z "${WDIR:-}" ]]
	then
		WDIR="$1"
	fi
	printf "\\e[?25h\\n\\e[1;48;5;109mBuildAPKs %s\\e[0m\\n" "${0##*/} prep.bash: Purging excess elements from directory $WDIR;  Please wait a moment..."
	for NAME in "${DLIST[@]}"
	do
 		find "$WDIR" -type d -name "$NAME" -exec rm -rf {} \; 2>/dev/null || printf "%s prep.bash WARNING: Could not process %s; Continuing...\\n" "${0##*/}" "$NAME" 
	done
	for NAME in "${FLIST[@]}"
	do
 		find "$WDIR" -type f -name "$NAME" -delete || printf "%s prep.bash WARNING: Could not process %s; Continuing...\\n" "${0##*/}" "$NAME"
	done
	find  "$WDIR" -type d -empty -delete || printf "%s prep.bash WARNING: Could not process %s; Continuing...\\n" "${0##*/}" "empty directories"
	printf "\\e[?25h\\n\\e[1;48;5;108mBuildAPKs %s\\e[0m\\n" "${0##*/} prep.bash $WDIR: DONE!"
}

declare -a DLIST # declare array for all superfluous directories
declare -a FLIST # declare array for all superfluous files
DLIST=(".idea" "bin" "gradle")
FLIST=("*.apk"  "*.aar" "*.jar" ".gitignore" "Android.kpf" "ant.properties" "build.gradle" "build.properties" "build.xml" ".classpath" "default.properties" "gradle-wrapper.properties" "gradlew" "gradlew.bat" "gradle.properties" "gradle.xml" "lint.xml" "local.properties" "makefile" "makefile.linux_pc" "org.eclipse.jdt.core.prefs" "pom.xml" "proguard.cfg" "proguard-project.txt" ".project" "project.properties" "R.java" ".settings" "settings.gradle" "WebRTCSample.iml")
# prep.bash EOF
