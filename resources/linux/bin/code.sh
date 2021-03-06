#!/usr/bin/env bash
#
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

# If root, ensure that --user-data-dir is specified
if [ "$(id -u)" = "0" ]; then
	while test $# -gt 0
	do
		if [[ $1 == --user-data-dir=* ]]; then
			DATA_DIR_SET=1
		fi
		shift
	done
	if [ -z $DATA_DIR_SET ]; then
		echo "It is recommended to start vscode as a normal user. To run as root, you must specify an alternate user data directory with the --user-data-dir argument." 1>&2
		exit 1
	fi
fi

if [ ! -L $0 ]; then
	# if path is not a symlink, find relatively
	VSCODE_PATH="$(dirname $0)/.."
else
	if which readlink >/dev/null; then
		# if readlink exists, follow the symlink and find relatively
		VSCODE_PATH="$(dirname $(readlink -f $0))/.."
	else
		# else use the standard install location
		VSCODE_PATH="/usr/share/@@NAME@@"
	fi
fi

# Allow users to override command-line options
if [[ -f $HOME/.vscode/code-flags.conf ]]; then
   CODE_USER_FLAGS="$(cat $HOME/.vscode/code-flags.conf)"
fi

ELECTRON="$VSCODE_PATH/@@NAME@@"
CLI="$VSCODE_PATH/resources/app/out/cli.js"
ELECTRON_RUN_AS_NODE=1 "$ELECTRON" "$CLI" "$CODE_USER_FLAGS" "$@"
exit $?
