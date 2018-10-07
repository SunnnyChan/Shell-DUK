#! /bin/bash -
##! @File    : tls_kit.sh
##! @Date    : 2016/04/22
##! @Author  : chenguang02@baidu.com
##! @Version : 1.0
##! @Todo    : 
##! @FileOut : 

SH_HOME="$(cd $(dirname  ${BASH_SOURCE[0]}); pwd)"
source "${SH_HOME}/lib/frame/main.sh"

FILES_TO_PRINT="ToolsList ToolsKitFrame DevelopStandard Install Changelog "

for file in ${FILES_TO_PRINT}
do
    echo "/**** ${file} ****/"
    cat "${REFER_ROOT}/${file}"
    echo -e "\n\n"
done

##! vim: ts=4 sw=4 sts=4 tw=100 ft=sh 
