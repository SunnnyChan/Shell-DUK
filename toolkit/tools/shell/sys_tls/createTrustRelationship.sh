#! /bin/bash -
##! @File    : createTrustRelationship.sh
##! @Date    : 2016/04/22
##! @Author  : chenguang02@baidu.com
##! @Version : 1.0
##! @Todo    : 
##! @FileOut : 


### ---------------------------- create trust relationship between two host ------------------------------
##! @TODO : create trust relationship between local host and remote host
##! @IN : $1 => remote hostname or ip
##! @IN : $2 => remote host username
function createTrustRelationship(){
    local l_remote_host="$1"
    local l_remote_user="$2"

    log_trace "${BASH_SOURCE[0]}" "$LINENO" "'create trust relationship, remote server info: [host]%s [user]%s ' ${l_remote_host} ${l_remote_user}"
    local l_home_dir="$(cd ${HOME}; pwd)"
    local l_private_key_file="${l_home_dir}/.ssh/id_rsa"
    local l_public_key_file="${l_home_dir}/.ssh/id_rsa.pub"

    local l_curr_time=$(date "+%Y%m%d_%H%M%S")
    # backup
    if [ -f "${l_private_key_file}" ]
    then
      mv "${l_private_key_file}" "${l_private_key_file}_${l_curr_time}"
    fi
    if [ -f "${l_public_key_file}" ]
    then
      mv "${l_public_key_file}" "${l_public_key_file}_${l_curr_time}"
    fi

    # generate key and sync to server
    ssh-keygen -t "rsa" -N "" -f ${l_private_key_file} >/dev/null

    if command -v ssh-copy-id >/dev/null 2>&1
    then
      ssh-copy-id -i ${l_public_key_file} ${l_remote_user}@${l_remote_host}
    else
        # ~/.ssh 必须存在，而且权限必须是 700，本机的私钥的权限必须设置成600
        ssh ${l_remote_user}@${l_remote_host} "mkdir -p ~/.ssh; chmod 700 ~/.ssh; cat >> ~/.ssh/authorized_keys; chmod 700 ~/.ssh/authorized_keys" <${l_public_key_file} >/dev/null 2>&1
    fi
    return 0
}


##! vim: ts=4 sw=4 sts=4 tw=100 ft=sh 
