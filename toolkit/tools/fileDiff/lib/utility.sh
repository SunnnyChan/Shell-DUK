##! @TODO : Shell 常用功能库
##! @VERSION : 1.0.3
##! @FILE   :utility.sh
##! @AUTHOR : SunnyChan
##! @Date : 2015/12/13

##! functions {
#function getFileNameSuffixByPidAndTime()
#function is2FilesHasSameContent()
#function tarOneFile()
#function delSuffixStr()
#function getIndexByValueFromArr()
#function printVersion()
#function getPidByPort()
#function createTrustRelationship()
#function parseIniConfig()
#function iniConf2Array()
#function getValueBySectionNameAndKey()
##! }

### ---------------------------- file -------------------------------
##! @TODO : generate a file name suffix string by process ID and current time
function getFileNameSuffixByPidAndTime(){
    echo  "$$_$(date '+%Y%m%d_%H%M%S')"
    return 0
}
##! @TODO : check tow files is same
function is2FilesHasSameContent(){
    local l_file1="$1"
    local l_file2="$2"

    local l_file1_md5value=$(md5sum $l_file1 | awk '{print $1}')
    local l_file2_md5value=$(md5sum $l_file2 | awk '{print $1}')
    if [[ "$l_file1_md5value" == "${l_file2_md5value}" ]]
    then
        return 0
    else
        return 1
    fi
}
##! @TODO : auto tar file in the file home directory
function tarOneFile(){
    local l_file_path="$1"
    if [ -f "${l_file_path}" ] || [ -d "${l_file_path}" ]
    then
        local l_file_basename=$(basename ${l_file_path})
        local l_file_dirname=$(dirname ${l_file_path})
        local l_tar_file_name="${l_file_basename}.tar.gz"
        (cd ${l_file_dirname} ; tar -zcf "${l_tar_file_name}" ${l_file_basename})
        if [[ "$?" == 0 ]]
        then
            return 0
        else
            log_fatal "${BASH_SOURCE[0]}" "$LINENO" "'tar file failed: [%s]' ${l_file_path}"
            return 1
        fi
    else
        log_fatal "${BASH_SOURCE[0]}" "$LINENO" "'file not exist: [%s]' ${l_file_path}"
        return 1
    fi
}
### ---------------------------- string ------------------------------
##! @TODO : delete string suffix
function delSuffixStr() {
    local l_str="$1"
    local l_suffix="$2"
    echo "${l_str%${l_suffix}}"
    return 0
}
### ---------------------------- numberic ------------------------------
function isInt(){
    local l_number="$1"
    local l_check_ret=$(awk -v number=${l_number} 'BEGIN{
    if (match(number,/^[0-9]+$/)){
            print "true"
        } else {
            print "false"
        }
    }')
    if [[ "${l_check_ret}" == "true" ]]
    then
        return 0
    else
        return 1
    fi
}
### ---------------------------- array ------------------------------
##! @TODO : get index by value in array
##! @IN   : $1 => array, tranfer values in this format : "${array[*]}"
##! @IN   : $2 =>
##! @OUT  : int array index
function getIndexByValueFromArr(){
    local l_value_list="$1"
    l_arr=($(echo ${l_value_list}))
    local l_value="$2"
    for key in "${!l_arr[@]}"
    do
        if [[ "${l_value}" == "${l_arr[$key]}" ]]
        then
            echo ${key}
            return 0
        fi
    done
    return 1
}
### ---------------------------- script ------------------------------
##! @TODO : print script version information
function printVersion() {
  	echo "${PROGRAM} ${VERSION}"
    return 0
}
### ---------------------------- process ------------------------------
##! @TODO : get process id by port number
function getPidByPort() {
    local l_port=$1
    local l_lsof_output=''
    local l_pid
    #if the process has started, return pid. else return 0
    if l_lsof_output=$(lsof -i:${l_port} 2>/dev/null)
    then
        local l_pid=$(echo "${l_lsof_output}"  | awk '{if (NR==2) print $2}')
        echo "${l_pid}"
        return 0
    fi
    return 1
}
##! @TODO : check a port whether to be used
function isPortUsed(){
    local l_port="$1"
    local l_min_port="1024"
    local l_max_port="65535"
    if isInt "$l_port"
    then
        if [ ${l_port} -le ${l_max_port} ] && [ ${l_port} -ge ${l_min_port} ]
        then
            if netstat -tnpl 2>/dev/null | grep ${l_port} >/dev/null 2>&1
            then
                return 1
            else
                return 0
            fi
        else
            log_fatal "${BASH_SOURCE[0]}" "$LINENO" "'port [%s] not in usable range: ' ${l_port}"
            return 2
        fi
    else
        log_fatal "${BASH_SOURCE[0]}" "$LINENO" "'port [%s] invalid: ' ${l_port}"
        return 2
    fi
}
### ---------------------------- parse ini file ------------------------------
##! @TODO : parse ini configuration file
##! @IN   : $1 => ini config file path
##! @OUT  : every ini config section include three lines
##!         first line  : section name
##!         second line : config key
##!         third line  : config value
function parseIniConfig(){
    local l_config_file="$1"
    if [ -f "$l_config_file" ]
    then
        egrep -v '[ \t]*#' ${l_config_file} |
        awk '{
            if (match($0, /\[.*\]/)){
                print(substr($0, RSTART+1, RLENGTH-2))
                while (getline nextLine){
                    if (match(nextLine, /\[.*\]/)){
                        for (key in arrConf){
                            strKey = strKey" "key
                            strValue = strValue" " arrConf[key]
                        }
                        printArr(arrConf)
                        delete arrConf
                        print(substr(nextLine, RSTART+1, RLENGTH-2))
                    } else {
                        if (match(nextLine, /=/)){
                            key =  substr(nextLine, 1, RSTART-1)
                            value = substr(nextLine, RSTART+1, length(nextLine)-RSTART)
                            arrConf[key] = value
                        }
                    }
                }
            }
        } END{printArr(arrConf)}
        function printArr(arrInput, strKey,strValue){
            for (key in arrInput){
                strKey = strKey" "key
                strValue = strValue" " arrInput[key]
            }
            print substr(strKey, 2, length(strKey)-1)
            print substr(strValue, 2, length(strValue)-1)
        }'
    else
        log_fatal "${BASH_SOURCE[0]}" "$LINENO" "'file not exist: '${l_config_file}"
        return 1
    fi
    return 0
}

##! @TODO : iniConfLines2Array
##! @IN   : $1 => ini config file path
##! @OUT  : global array
##!     array ARR_INI_SECTION_NAME
##!     array ARR_INI_SECTION_KEY_$INDEX
##!     array ARR_INI_SECTION_VALUE_$INDEX
function iniConf2Array(){
    local l_ini_file_path="$1"
    if [ -f "$l_ini_file_path" ]
    then
        local l_ini_info="$(parseIniConfig ${l_ini_file_path})"
        # l_section_lineno stand for line number in a section, values in : 1,2,3
        local l_section_lineno=0
        # section count equals to SECTION_INDEX + 1
        INI_SECTION_INDEX=0
        # read section info, and save to array
        while read line
        do
            ((l_section_lineno ++))
            case $l_section_lineno in
                # first line in a record
                1)  ARR_INI_SECTION_NAME[${INI_SECTION_INDEX}]=${line}
                    ;;
                # second line in a record
                2)
                    # for every section, create tow arrays to save key and value for conf info
                    eval "ARR_INI_SECTION_KEY_${INI_SECTION_INDEX}=(${line})"
                    ;;
                # third line in a record
                3)
                    # array to save value
                    eval "ARR_INI_SECTION_VALUE_${INI_SECTION_INDEX}=(${line})"
                    # a section record end
                    ((l_section_lineno = 0))
                    ((INI_SECTION_INDEX ++))
                    ;;
            esac
        done <<EOF
        $(echo "${l_ini_info}")
EOF
        # the real max index value
        ((INI_SECTION_INDEX --))
    else
        log_fatal "${BASH_SOURCE[0]}" "$LINENO" "'file not exist: '${l_ini_file_path}"
        return 1
    fi
    return 0
}

##！get value by setion name and key in ini file
##! @IN   : $1 => array, tranfer values in this format : "${array[*]}"
##! @IN   : $2 =>
##! @OUT  : null
function getValueBySectionNameAndKey(){
    local l_sec_name="$1"
    local l_key="$2"
    local l_sec_index=''
    local l_key_index=''
    local l_value=''
    local l_arr_values=''
    eval "l_arr_values=\${ARR_INI_SECTION_NAME[@]}"
    l_sec_index=$(getIndexByValueFromArr "${l_arr_values[*]}" ${l_sec_name})
    if [ -z "$l_sec_index" ]
    then
        printf ''
        return 1
    fi
    eval "l_arr_values=\${ARR_INI_SECTION_KEY_${l_sec_index}[@]}"
    l_key_index=$(getIndexByValueFromArr "${l_arr_values[*]}" ${l_key})
    if [ -z "$l_key_index" ]
    then
        printf ''
        return 1
    fi
    eval "l_value=\${ARR_INI_SECTION_VALUE_${l_sec_index}[${l_key_index}]}"
    echo ${l_value}
    return 0
}
##! process bar
##! @IN  : 进度条打印的 信息
function strProgressBar(){
    local info_for_print="$1"
    local interval=15                 # Sleep time between "twirls"
    local t_count="0" 
    if [ -z "${info_for_print}" ] 
    then
        info_for_print='... ... ...'
    fi
    while true
    do
        sleep ${interval} 
        t_count=$(($t_count + 1))          # Increment the TCOUNT
        case $t_count in
            "1") redPrint ${info_for_print}
                ;;
            "2") bluePrint ${info_for_print}
                ;;
            "3") greenPrint ${info_for_print}
                ;;
            "4") yellowPrint ${info_for_print}
                ;;
            "5") purplePrint ${info_for_print}
                ;;
            *  ) t_count="0" 
                ;;      # Reset the TCOUNT to "0",zero
        esac
    done
} 
##! 旋转式进度条
function rotateProgressBar(){
    local interval=15                  # Sleep time between "twirls"
    local t_count="0"                 # For each TCOUNT the line twirls one increment
    while true                        # Loop forever ...until this function is killed
    do
        t_count=$(($t_count + 1))          # Increment the TCOUNT
        case $t_count in
            "1") echo -e '-' "\b\c"
                sleep $interval
                ;;
            "2") echo -e '\\' "\b\c"
                sleep $interval
                ;;
            "3") echo -e "|\b\c"
                sleep $interval
                ;;
            "4") echo -e "/\b\c"
                sleep $interval
                ;;
            *  ) t_count="0" ;;      # Reset the TCOUNT to "0",zero
        esac
    done
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
