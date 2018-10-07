#! /bin/bash -
##! @File    : programe_php.sh
##! @Date    : 2016/05/13
##! @Author  : chenguang02@baidu.com
##! @Version : 1.0
##! @Todo    : 
##! @FileOut : 

##! @TODO : 查找类名定义位置
##! @IN   : $1 类名
##! @IN   : $2 查找目录
function grepPhpClass(){
    local className=$1
    shift 1
    local dirPath="$@"
    [ -z "$dirPath" ] && { dirPath=$(pwd); echo -e $(yellowPrint "NOTICE: ")"\c"; greenPrint "search in ${dirPath}"; }
    fgrep -n -w "${className}" -r ${dirPath} | egrep --color "class *${className}"
}
##! vim: ts=4 sw=4 sts=4 tw=100 ft=sh 
