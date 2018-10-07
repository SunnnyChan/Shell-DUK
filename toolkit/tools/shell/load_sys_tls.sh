#! /bin/bash -
##! @File    : load_sys_tls.sh
##! @Date    : 2016/05/13
##! @Author  : sunnnychan@gmail.com
##! @Version : 1.0
##! @Todo    : 
##! @FileOut : 
##! @Brief   : 

LOAD_SYS_TLS_HOME="$(cd $(dirname ${BASH_SOURCE[0]}); pwd)"
source "${LOAD_SYS_TLS_HOME}/sys_tls/file.sh"
source "${LOAD_SYS_TLS_HOME}/sys_tls/http.sh"
source "${LOAD_SYS_TLS_HOME}/sys_tls/programe_c.sh"
source "${LOAD_SYS_TLS_HOME}/sys_tls/programe_php.sh"
source "${LOAD_SYS_TLS_HOME}/sys_tls/text_porecess.sh"
source "${LOAD_SYS_TLS_HOME}/sys_tls/sys_manage.sh"

unset LOAD_SYS_TLS_HOME
##! vim: ts=4 sw=4 sts=4 tw=100 ft=sh 
