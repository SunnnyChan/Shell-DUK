#! /bin/bash -
##! @File    : set_env.sh
##! @Date    : 2016/04/22
##! @Author  : sunnnychan@gmail.com
##! @Version : 1.0
##! @Todo    : 
##! @FileOut : 

SCRIPT_HOME="$(cd $(dirname  ${BASH_SOURCE[0]})/..; pwd)"
TLS_KIT_BIN_DIR="${SCRIPT_HOME}/bin"

if [ -n "${PATH}" ]
then
    PATH="${TLS_KIT_BIN_DIR}:${PATH}"
else
    PATH="${TLS_KIT_BIN_DIR}"
fi

source "${SCRIPT_HOME}/lib/shell/loadShLib.sh"
source "${SCRIPT_HOME}/tools/shell/load_sys_tls.sh"

unset TLS_KIT_BIN_DIR

##! vim: ts=4 sw=4 sts=4 tw=100 ft=sh 
