#! /bin/bash -
##! @File    : tls_shell.sh
##! @Date    : 2016/04/22
##! @Author  : chenguang02@baidu.com
##! @Version : 1.0
##! @Todo    : 
##! @FileOut : 

source "$(dirname ${BASH_SOURCE[0]})/main.sh"

TLS_SHELL_ROOT="${TLS_ROOT}/shell"
LIB_SHELL_ROOT="${LIB_ROOT}/shell"
LOG_SHELL_ROOT="${LOG_ROOT}/shell"

INIT_SHELL_SCRIPT="${LIB_SHELL_ROOT}/init.sh"
source ${INIT_SHELL_SCRIPT}

