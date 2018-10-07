#! /bin/sh -
# diffWithOnline : diff code between previous-online with current-online 
# by sunnnychan@gmail.com
# version : v1.0.0
# 2015/11/20

#------------- global variable ------------------
VERSION="1.0.0"
SCRIPT_HOME=$( (cd "`dirname $0`"; cd ..; pwd) )
PROGRAM=$(basename $0 .sh)
PRO_LIB_DIR="${SCRIPT_HOME}/lib"
PRO_SCRIPT_DIR="${SCRIPT_HOME}/script"
PRO_CONF_DIR="${SCRIPT_HOME}/conf"
PRO_LOG_DIR="${SCRIPT_HOME}/log"
PRO_FILE_TMP="${SCRIPT_HOME}/diffFile"

#------------- script -------------------------
SCRIPT_FILEDIFF="${PRO_SCRIPT_DIR}/fileDiff.sh"

#------------- initialize ----------------------
# initalize run-time env
source "${PRO_LIB_DIR}/initEnv.sh"
# load lib 
source "${PRO_LIB_DIR}/logLib.sh"
source "${PRO_LIB_DIR}/printLib.sh"
source "${PRO_LIB_DIR}/utility.sh"
# set log configuration
log_init "${PRO_LOG_DIR}" "${PROGRAM}" "16" "16"

#---------- define conf file -----------------
CONF_INI_FILE="${PRO_CONF_DIR}/${PROGRAM}.ini"
RSYNC_EXCLUDE_FILE="${PRO_CONF_DIR}/rsyncExcludeFile.list"
#------------ function -----------------------
function printUsage() {
cat << EOF
Usage  : 
    sh $0 [app_name] [directory] 
Params :
    app_name, in fact, app_name correspond to section name in ini conf file.
    directory , code absolute directory on development env.
EOF
return 0
}
#------------ main flow -----------------------
# 解析 conf
iniConf2Array "${CONF_INI_FILE}"
# 查找相关的配置信息存放的数组
sec_name=$1
conf_sec_index=''
for index in ${!ARR_INI_SECTION_NAME[@]} 
do
    if [[ "$sec_name" == ${ARR_INI_SECTION_NAME[${index}]} ]]
    then
        conf_sec_index=${index}
        break
    fi
done
if [ -z ${conf_sec_index} ]
then
    log_fatal "${BASH_SOURCE[0]}" "$LINENO" "'find no confs of [%s]' $sec_name"
    exit
fi
# 创建存放线上Code的临时文件
code_tmp_dir_ol="${PRO_FILE_TMP}/${sec_name}_online"
mkdir -p ${code_tmp_dir_ol}
code_tmp_dir_dev="${PRO_FILE_TMP}/${sec_name}"
rm -rf "${code_tmp_dir_dev}"
mkdir -p "${code_tmp_dir_dev}"
# 获取相关配置信息
online_host=''
code_home=''
is_diff_all=''
diff_dirs=''
dev_host=''
eval "arr_values=\${ARR_INI_SECTION_KEY_$conf_sec_index[@]}"
arr_values=($(echo $arr_values))
if index=$(getIndexByValueFromArr "${arr_values[*]}" "online_code_path")
then
    eval "online_code_path=\${ARR_INI_SECTION_VALUE_$conf_sec_index[index]}"
else
    log_fatal "${BASH_SOURCE[0]}" "$LINENO" "online_host not set in ini file'"
fi
if index=$(getIndexByValueFromArr "${arr_values[*]}" "dev_code_path")
then
    eval "dev_code_path=\${ARR_INI_SECTION_VALUE_$conf_sec_index[index]}"
else
    log_fatal "${BASH_SOURCE[0]}" "$LINENO" "code_home not set in ini file'"
fi
if index=$(getIndexByValueFromArr "${arr_values[*]}" "is_diff_all")
then
    eval "is_diff_all=\${ARR_INI_SECTION_VALUE_$conf_sec_index[index]}"
else
    log_fatal "${BASH_SOURCE[0]}" "$LINENO" "is_diff_all not set in ini file'"
fi
if [[ "${is_diff_all}"  == '0' ]]
then
    if index=$(getIndexByValueFromArr "${arr_values[*]}" "diff_dirs")
    then
        eval "diff_dirs=\${ARR_INI_SECTION_VALUE_$conf_sec_index[index]}"
    else
        log_fatal "${BASH_SOURCE[0]}" "$LINENO" "diff_dirs not set in ini file'"
    fi
fi 

# sync code online
rsync -azcq --exclude-from=${RSYNC_EXCLUDE_FILE} "${online_code_path}/" ${code_tmp_dir_ol%/} 
# sync code offline
if [[ "${is_diff_all}"  == '1' ]]
then
    rsync -azcq -azcq --exclude-from=${RSYNC_EXCLUDE_FILE} "${dev_code_path}/" ${code_tmp_dir_dev%/} 
elif [[ "${is_diff_all}"  == '0' ]]
then
    if [ -z "${diff_dirs}" ]
    then
        log_fatal "${BASH_SOURCE[0]}" "$LINENO" "'Error: diff_dirs not set in ini conf file.'"   
        exit 1
    fi
    for dir in "${diff_dirs}"
    do
        rsync -azcq -azcq --exclude-from=${RSYNC_EXCLUDE_FILE} "${dev_code_path}/${dir}" ${code_tmp_dir_dev%/}
    done
fi
# diff code
sh ${SCRIPT_FILEDIFF} -1 ${code_tmp_dir_dev} ${code_tmp_dir_ol} 
