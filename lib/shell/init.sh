#! /bin/bash -
##! @File    : init.sh
##! @Date    : 2016/04/22
##! @Author  : sunnnychan@gmail.com
##! @Version : 1.0
##! @Todo    : 
##! @FileOut : 

INIT_SH_HOME="$(cd $(dirname  ${BASH_SOURCE[0]}); pwd)"
## init env
source "${INIT_SH_HOME}/initEnv.sh"

## load library
source "${INIT_SH_HOME}/loadShLib.sh"

unset INIT_SH_HOME

## init log
log_init "${LOG_SHELL_ROOT}" "${PROGRAME}" "16" "8"
