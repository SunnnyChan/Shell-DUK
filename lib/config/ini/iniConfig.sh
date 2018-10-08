##! @TODO : parse ini configuration file
##! @IN : $1 => ini config file path
##! @OUT : every ini config section include three lines
##! first line : section name 
##! second line : config key
##! third line : config value
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
                            key = substr(nextLine, 1, RSTART-1)
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
##! @IN : $1 => ini config file path
##! @OUT : global array
##! array ARR_INI_SECTION_NAME 
##! array ARR_INI_SECTION_KEY_$INDEX
##! array ARR_INI_SECTION_VALUE_$INDEX
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
                1) ARR_INI_SECTION_NAME[${INI_SECTION_INDEX}]=${line}
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

##! @TODO : get index by value in array 
##! @IN : $1 => array, tranfer values in this format : "${array[*]}"
##! @IN : $2 => 
##! @OUT : int array index
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

##！@TODO get value by setion name and key in ini file
##! @IN : $1 => section name in ini file
##! @IN : $2 => key
##! @OUT : value
function getValueBySectionNameAndKey(){
    local l_sec_name="$1"
    local l_key="$2"
    local l_sec_index=''
    local l_key_index=''
    local l_value=''
    local l_arr_values=''
    eval "l_arr_values=\${ARR_INI_SECTION_NAME[@]}"
    l_sec_index=$(getIndexByValueFromArr "${l_arr_values[*]}" ${l_sec_name})
    eval "l_arr_values=\${ARR_INI_SECTION_KEY_${l_sec_index}[@]}"
    l_key_index=$(getIndexByValueFromArr "${l_arr_values[*]}" ${l_key}) 
    eval "l_value=\${ARR_INI_SECTION_VALUE_${l_sec_index}[${l_key_index}]}"
    echo ${l_value}
    return 0
}

function iniConf2AssociativeArray(){
    local l_ini_file_path="$1"
    if [ -f "$l_ini_file_path" ]
    then 
        local l_ini_info="$(parseIniConfig ${l_ini_file_path})"
        # l_section_lineno stand for line number in a section, values in : 1,2,3
        local l_section_lineno=0
        # read section info, and save to array
        local l_section_name=''
        local l_config_keys=''
        local l_arr_config_value=''
        while read line 
        do
            ((l_section_lineno ++)) 
            case $l_section_lineno in
                1) l_section_name=${line}
                    ;;
                2) l_config_keys=${line}
                    ;;
                3) eval "l_arr_config_value=(${line[@]})"
                    local l_fields_index=0
                    for config_key in ${l_config_keys}
                    do
                        eval "ARR_INI_CONFIG_KV_${l_section_name}[${config_key}]=\${l_arr_config_value[\${l_fields_index}]}"
                        ((l_fields_index ++))
                    done
                    ((l_section_lineno = 0)) 
                    ;;
            esac
        done <<EOF
        $(echo "${l_ini_info}")
EOF
    else
        log_fatal "${BASH_SOURCE[0]}" "$LINENO" "'file not exist: '${l_ini_file_path}"
        return 1
    fi
    return 0
}
