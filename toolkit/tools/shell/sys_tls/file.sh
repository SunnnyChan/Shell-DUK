#! /bin/bash -
##! @File    : file.sh
##! @Date    : 2016/05/13
##! @Author  : sunnnychan@gmail.com
##! @Version : 1.0
##! @Todo    : 
##! @FileOut : 

##! @TODO : 打印scp、rsync命令路径参数
##! @IN   : $1 => 需copy的文件或路径 
##! @OUT  : user@hostname:file_path
function genScpPath(){
    log_init "$HOME" "shTls" "" "2"
    local filePath="$1"
    local hostName="$(hostname)"
    local userName="$(whoami)"
   
    if [[ -n "$filePath" ]]
    then
        if [[ -d "$filePath"  ]] || [[ -f "$filePath" ]]
        then
            echo "scp -r ${userName}"'@'"${hostName}"':'"$(readlink -f ${filePath})"
        else
            log_fatal "${BASH_SOURCE[0]-$0}" "${FUNCNAME}" "$filePath' not a real path.'"
        fi
    else
        echo "scp -r ${userName}@${hostName}:$(pwd) "
    fi
}

##! @TODO : 快速备份文件
##! @IN   : $1 待备份文件
##! @IN   : $2 备份目录，可以不设置，则备份至当前目录
function backupFile(){
    local l_file="$1"
    local l_back_dir="$2"
    local l_name_suffix=$(date "+%Y%m%d_%H%M%S")
    local l_back_file_name="${l_file%/}_${l_name_suffix}.tar.gz"
    ! [ -f "$l_file" ] && ! [ -d "$l_file" ] && { echo "Error: file to backup not exist." ; return 1; }
    tar -zcf "${l_back_file_name}" ${l_file}
    if [ -n "${l_back_dir}" ]
    then 
        mkdir -p ${l_back_dir}
        mv "${l_back_file_name}" ${l_back_dir}
    fi
    return 0
}


##! vim: ts=4 sw=4 sts=4 tw=100 ft=sh 
