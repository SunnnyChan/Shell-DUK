#! /bin/bash -
##! @File    : text_porecess.sh
##! @Date    : 2016/05/13
##! @Author  : sunnnychan@gmail.com
##! @Version : 1.0
##! @Todo    : 
##! @FileOut : 
##! @Brief   : 文本处理

##! 文本编码转换
function utf82gb2312(){
    local file="$1"
    if [ ! -f  "$file" ] 
    then
        echo 'Error : file not exist.'
        return 1
    fi
    local tmp_file_name="/tmp/utf82gb2312_tmp"
    if ! iconv -f utf8 -t gb2312 ${file} >${tmp_file_name} 2>/dev/null 
    then
        echo 'Error : utf82gb2312 failed.'
        return 1
    fi
    mv ${tmp_file_name} ${file}
    return 0
}

function gb23122utf8(){
    local file="$1"
    if [ ! -f  "$file" ] 
    then
        echo 'Error : file not exist.'
        return 1
    fi
    local tmp_file_name="/tmp/gb23122utf8_tmp"
    if ! iconv -t utf8 -f gb2312 ${file} >${tmp_file_name} 2>/dev/null 
    then
        echo 'Error : gb23122utf8 failed.'
        return 1
    fi
    mv ${tmp_file_name} ${file}
    return 0
}

##! 输出文件编码类型
function fileencoding(){
    if (($# < 1))
    then
        exit 1;
    fi 
    local char_sets='utf-8 gb2312 cp936 unicode '
    for file in $@
    do
        if ! [ -f $file ]
        then
            echo  "$(basename ${file}) : file no exist"
            continue
        fi
        for char_set in ${char_sets}
        do
            if iconv -f=${char_set} -t=${char_set} $file >/dev/null  2>&1
            then
                echo  "$(basename ${file}) : ${char_set}"
                continue 2
            fi
        done
        echo  "$(basename ${file}) : unknow file encoding"
    done 
}

##! vim: ts=4 sw=4 sts=4 tw=100 ft=sh 
