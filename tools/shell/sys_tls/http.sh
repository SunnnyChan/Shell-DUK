#! /bin/bash -
##! @File    : http.sh
##! @Date    : 2016/05/13
##! @Author  : sunnnychan@gmail.com
##! @Version : 1.0
##! @Todo    : 
##! @FileOut : 
##! @Brief   : HTTP 协议

##! @IN   : $1 string
function urlencode(){
    # urlencode <string>
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c"
        esac
    done
}
##! @IN   : $1 string
function urldecode() {
    # urldecode <string>    
    echo "$1" | awk '
    {
         for (i = 0x20; i < 0x40; ++i) {
             repl = sprintf("%c", i);
             if ((repl == "&") || (repl == "\\"))
                 repl = "\\" repl;
             gsub(sprintf("%%%02X", i), repl);
             gsub(sprintf("%%%02x", i), repl);
         }
         print
     }
    '
}

##! vim: ts=4 sw=4 sts=4 tw=100 ft=sh 
