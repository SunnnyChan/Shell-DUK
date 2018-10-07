#! /bin/bash -
##! @File    : install_toolkit.sh
##! @Date    : 2016/06/12
##! @Author  : chenguang02@baidu.com
##! @Version : 1.0
##! @Todo    : 
##! @FileOut : 
##! @Brief   : 

#!/bin/bash
set -e
trap 'echo Error on line $BASH_SOURCE:$LINENO' ERR
trap 'rm -f $tmp' EXIT

if [[ -n "$TOOLKIT_ROOT" && -d "$TOOLKIT_ROOT" && -f "$TOOLKIT_ROOT/bin/toolkit" ]]
then
    echo "Toolkit is already installed in your system"
    exit 1
fi

TOOLKIT_REPO="http://toolkit.baidu.com"
TOOLKIT_LOCATION="$TOOLKIT_REPO/toolkit"

DEFAULT_TOOLKIT_ROOT="$HOME/.toolkit"

if [[ "$1" == "-d" ]]
then
    echo "Where would you want to install jumbo?"
    echo -n "[$DEFAULT_TOOLKIT_ROOT]: "
    read TOOLKIT_ROOT
    if [ -z "$TOOLKIT_ROOT" ]
    then
        TOOLKIT_ROOT="$DEFAULT_TOOLKIT_ROOT"
    fi
    if [ "${TOOLKIT_ROOT:0:1}" != "/" ]
    then
        TOOLKIT_ROOT="$PWD/$TOOLKIT_ROOT"
    fi
else
    TOOLKIT_ROOT="$DEFAULT_TOOLKIT_ROOT"
fi

mkdir -p "$TOOLKIT_ROOT"
bash -c "$( curl "$TOOLKIT_LOCATION" 2>/dev/null )" jumbo -n -r "$TOOLKIT_ROOT" -p "$TOOLKIT_REPO" install jumbo
if ! grep "$TOOLKIT_ROOT/etc/bashrc" "$HOME/.bashrc" 2>/dev/null
then
    echo "[[ -s \"$TOOLKIT_ROOT/etc/bashrc\" ]] && source \"$TOOLKIT_ROOT/etc/bashrc\"" >> "$HOME/.bashrc"
fi

##! vim: ts=4 sw=4 sts=4 tw=100 ft=sh 
