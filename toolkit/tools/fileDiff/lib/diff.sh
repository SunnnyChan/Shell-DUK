# create by chenguang02@baidu.com
# 2015/11/18

##!
function diff2Files(){
    local l_file1_path=$1
    local l_file2_path=$2

    local l_file1_name=$(basename ${l_file1_path})
    local l_file2_name=$(basename ${l_file2_path})
    local l_report_file_suffix=$(getFileNameSuffixByPidAndTime)
    local l_diff_report_file="${l_file1_name}_${l_file2_name}_${l_report_file_suffix}_diff.html"
    if [[ "${l_file1_name}" == "${l_file2_name}" ]]
    then
        l_diff_report_file="${l_file1_name}_${l_report_file_suffix}_diff.html"
    fi
    l_diff_report_file="${PRO_REPORT_DIR}/${l_diff_report_file}"

    fileDiff "${l_file1_path}" "${l_file2_path}" "${l_diff_report_file}"
    tarAndDownloadDiffReportFile ${l_diff_report_file}
    return $?
}
##!
function diff2Dirs(){
    diff2DirByStdFlow "$1" "$2"   
}
##!
function diff2DirStdDir1(){
    diff2DirByStdFlow "$1" "$2"
}
##!
function diff2DirStdDir2(){
    diff2DirByStdFlow "$2" "$1"
}
##!
function diff2DirByStdFlow(){
    local l_dir1=$1
    local l_dir2=$2
    l_dir1=$(delSuffixStr "$l_dir1" "/")
    l_dir2=$(delSuffixStr "$l_dir2" "/")
    if [ -d "$l_dir1" ] && [ -d "$l_dir2" ]
    then
        local l_std_dir_name=${l_dir1##*/}
        local l_dir_name=${l_dir2##*/}
        local l_report_dir_name="${l_std_dir_name}_${l_dir_name}"
        if [[ "$l_std_dir_name" = "${l_dir_name}" ]]
        then
            l_report_dir_name="${l_std_dir_name}"
        fi
        l_report_dir_name="${l_report_dir_name}_$(getFileNameSuffixByPidAndTime)_diff"
        l_report_dir_path="${PRO_REPORT_DIR}/${l_report_dir_name}"
        mkdir -p "${l_report_dir_path}"
        
        local l_file_diff_info=$(diffDirByStd "${l_dir1}" "${l_dir2}" "${l_report_dir_path}")

        writeIndexHtml "${l_report_dir_path}" "${l_dir1}" "${l_file_diff_info}"
        tarAndDownloadDiffReportFile ${l_report_dir_path}
        return $?
    else 
        log_fatal "${BASH_SOURCE[0]}" "$LINENO" "'must be two directorys. [%s] [%s]' $l_dir1 $l_dir2"
        return 1
    fi
}
##!
function diffDirByStd(){
    local l_std_dir_path=$1
    local l_dir_path=$2
    local l_report_dir_path=$3
    # 多进程执行
    local thread_num_ctrl_file="/tmp/$$.fifo"
    mkfifo ${thread_num_ctrl_file}
    exec 5<>${thread_num_ctrl_file}
    rm -rf ${thread_num_ctrl_file}
    {   
        for ((i = 1; i <= ${THREAD_NUM}; i ++))
        do  
            echo
        done
    } >&5
    for file in $(find ${l_std_dir_path} | grep -v $(cat $DIFF_EXCLUDE_LIST))
    do
        if [ -d ${file} ] 
        then
            mkdir -p ${file/#${l_std_dir_path}/${l_report_dir_path}} 
        elif [ -f ${file}  ]
        then
            local l_file2=${file/#${l_std_dir_path}/${l_dir_path}}
            local l_diff_html="${file/#${l_std_dir_path}/${l_report_dir_path}}_diff.html"
            if [ -f ${l_file2} ]
            then
                if is2FilesHasSameContent "${file}" "${l_file2}"
                then
                    echo  ${file} "equal"
                else
                    read
                    {
                        fileDiff "${file}" "${l_file2}" "${l_diff_html}"
                        echo >&5
                    } &
                    echo  ${file} "notequal" "${l_diff_html#${l_report_dir_path}/}"
                fi
            else 
                writeHtmlHead > ${l_diff_html}
                cat ${file} >> ${l_diff_html}
                writeHtmlEnd >> ${l_diff_html}
                echo ${file} "notexist" "${l_diff_html#${l_report_dir_path}/}"
            fi
        fi
    done <&5
    wait
    exec 5>&- 
    return 0
}
##!
function fileDiff(){
    local l_file1_path=$1
    local l_file2_path=$2
    local l_report_path=$3
    
    diff ${l_file1_path} ${l_file2_path} |
       sh  ${SCRIPT_DIFF2HTML} ${l_file1_path} ${l_file2_path} > ${l_report_path}
    return $?
}
##!
function writeIndexHtml(){
    local l_index_html_path="$1/index.html"
    local l_file=$2
    local l_diff_info="$3"
    > ${l_index_html_path}
    writeHtmlHead >> ${l_index_html_path}
    writeHtml1FileBoday "${l_file}" "${l_diff_info}" >> ${l_index_html_path}
    writeHtmlEnd >> ${l_index_html_path}
}
function writeHtml1FileBoday(){
    local l_file_name=$1
    local l_body_info="$2"
    local l_table_line=$(echo "${l_body_info}" | wc -l)
cat <<EOF
<table width="100%">
    <tr>
        <th>&nbsp;</th>
        <th width="45%"><strong><big>${l_file_name}</big></strong></th>
        <th>&nbsp;</th>
        <th>&nbsp;</th>
        <th width="45%"><strong><big></big></strong></th>
    </tr>
    <tr>
        <td width="16">&nbsp;</td>
        <td>
        ${l_table_line} lines<br/>
        <hr/>
        </td>
        <td width="16">&nbsp;</td>
        <td width="16">&nbsp;</td>
        <td>
        <br/>
        <hr/>
        </td>
    </tr> 
EOF
    local line_count=0
    local line_content=''
    local line_color=''
    local line_diff_report_link=''
    while read line 
    do
        ((line_count ++))
        line_content=$(echo $line | awk '{print $1}')
        line_color=$(echo $line | awk '{print $2}')
        line_diff_report_link=$(echo $line | awk '{print $3}')
        case $line_color in
            notequal) 
                line_color="red"
                ;;
            equal) 
                #line_color="black" #相等的文件不再展示
                continue
                ;;
            notexist) 
                line_color="green"
                ;;
        esac
        echo "    <tr>"
        echo "      <td class=\"linenum\">${line_count}</td>"
        echo "      <td class=\"normal\">
                      <a href=\"${line_diff_report_link}\"><font color=\"${line_color}\">${line_content}</font></a>
                    </td>"
        echo "      <td width="16">&nbsp;</td>"
        echo "      <td class=\"linenum\"></td>"
        echo "      <td class=\"normal\"></td>"
        echo "    </tr>"
done << EOF
$(echo "${l_body_info}")
EOF
    echo "</table>"
}
##!
function writeHtml2FileBoday(){
cat <<EOF
<table>
    <tr>
        <th>&nbsp;</th>
        <th width="45%"><strong><big>${file1}</big></strong></th>
        <th>&nbsp;</th>
        <th>&nbsp;</th>
        <th width="45%"><strong><big>${file2}</big></strong></th>
    </tr>
    <tr>
        <td width="16">&nbsp;</td>
        <td>
        ${#file1_lines[@]} lines<br/>
        <hr/>
        </td>
        <td width="16">&nbsp;</td>
        <td width="16">&nbsp;</td>
        <td>
        ${#file2_lines[@]} lines<br/>
        <hr/>
        </td>
    </tr> 
EOF
}
##!
function writeHtmlHead(){
   cat <<EOF
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"
 "http://www.w3.org/TR/REC-html40/loose.dtd">
<html>
<head>
    <title>Diff directorys</title>
<style>
TABLE { border-collapse: collapse; border-spacing: 0px; font-size: 15px}
TD.linenum { color: #909090; 
   text-align: right;
   vertical-align: top;
   font-weight: bold;
   border-right: 1px solid black;
   border-left: 1px solid black; }
TD.added { background-color: #DDDDFF; font-size: 15px;}
TD.modified { background-color: #BBFFBB; font-size: 15px;}
TD.removed { background-color: #FFCCCC; font-size: 15px}
TD.normal { background-color: #FFFFE1; font-size: 15px}
body {
  background-color: #ffffff;
  font-family: Menlo,Monaco,Consolas,"Andale Mono","lucida console","Courier New",monospace;
  font-size: 13px;
  line-height: 1.5;
  color: #666666;
  font-weight: 500;
}
</style>
</head>
<body>
EOF
}
##!
function writeHtmlEnd(){
cat <<EOF
<hr/>
<i>Generated by <b>fileDiff</b> on $(date +"%Y-%m-%d %H:%M:%S") Author: chenguang02</i> 
</body>
</html>
EOF
}
##!
function tarAndDownloadDiffReportFile(){
    local l_diff_report_file=$(delSuffixStr $1)
    tarOneFile "${l_diff_report_file}"
    if [[ $? != "0" ]]
    then
        return 1
    fi
    rm -rf ${l_diff_report_file}
    local l_tar_file_path="${l_diff_report_file}.tar.gz"
    log_trace "${BASH_SOURCE[0]}" "$LINENO" "'Download diff report file. [%s] ' ${l_tar_file_path##*/} " 
    # log content may not print to terminal at once, so use sync to synchronize data
    sync
    #sz "${l_tar_file_path}" 
    # fileDiff 工具没有整合到框架中，不能使用框架的变量
    sh '../../bin/sz' "${l_tar_file_path}"  
    return $?
}

