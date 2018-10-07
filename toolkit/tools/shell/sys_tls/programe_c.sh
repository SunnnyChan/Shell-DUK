#! /bin/bash -
##! @File    : programe_c.sh
##! @Date    : 2016/05/13
##! @Author  : chenguang02@baidu.com
##! @Version : 1.0
##! @Todo    : 
##! @FileOut : 
##! @brief   :  C language programe 

##! @TODO : 查找动态库文件位置
##! @IN   : 动态库文件名
##! @OUT  : 动态库文件路径
function grepSoPath(){
    local soFilePath="$1"

    local soFileDict="/etc/ld.so.cache"
    if [[ -n "$soFileDict" ]]
    then
        # 先查询 LD_LIBRARY_PATH 
        find $(echo $LD_LIBRARY_PATH | sed 's/\:/\n/g') -name  "*.so.*" | /bin/grep --color "/${soFilePath}"
        strings "$soFileDict" | /bin/grep --color "/${soFilePath}"
    fi
}

##! @TODO : Linux下查找宏定义
##! @IN   : $1 查找的目录
##! @IN   : $2 要查找的宏
##! @OUT  : 宏所在的文件
function searchMarco(){
    if (($# != 2))
    then 
       echo "Fail,need more arguments."
       exit -1
    fi
    local marco=$2
    local find_dir=$1
    find $1 -name *.h 2>/dev/null | while read  file_h
    do
        if grep $2 $file_h
        then 
            echo $file_h
        fi
    done
    return 0
}

##! vim: ts=4 sw=4 sts=4 tw=100 ft=sh 
