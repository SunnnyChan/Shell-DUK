##! @TODO : Shell 日志库
##! @VERSION : 1.0.1
##! @FILE : log.sh
##! @AUTHOR : SunnyChan
##! @Date : 2015/07/20

#################################################################################
# 日志级别
# 1:只打印fatal级别日志
# 2:打印 fatal warning
# 4:打印 fatal warning notice
# 8:打印 fatal warning notice trace
# 16:打印 fatal warning notice trace debug
# 打印到日志文件的日志级别默认设置为16，打印到终端的日志级别默认为2
# 可以在初始化时重置
#################################################################################

# 打印到日志中的各个级别的标识
LOG_DEBUG_STR="DEBUG"
LOG_TRACE_STR="TRACE"
LOG_NOTICE_STR="NOTICE"
LOG_WARNING_STR="WARNING"
LOG_FATAL_STR="FATAL"

# 日志级别
LOG_LEVEL_DEBUG=16
LOG_LEVEL_TRACE=8
LOG_LEVEL_NOTICE=4
LOG_LEVEL_WARNING=2
LOG_LEVEL_FATAL=1

# 打印到日志文件的日志级别
LOG_FILE_LEVEL='16'
# 打印到终端的日志级别
LOG_TERM_LEVEL='2'
# 日志文件路径
LOG_DIR=''
# 日志文件名
LOG_NAME=''
# 日志记录ID
LOG_ID=''

# 普通日志文件 和 错误日志文件
LOG_FILE=''
LOG_FILE_WF=''

##! @TODO : initialize log.
##! 初始化日志配置，设置日志文件路径和名称、需要打印至日志文件和终端的的日志级别。
##! 如果日志级别设置为空，则不打印。
##! @IN : $1 => directory to write log
##! @IN : $2 => log file name
##! @IN : $3 => log level (write to file) : 1,2,4,8,16
##! @IN : $4 => log level (ouput to terminal) : 1,2,4,8,16
function log_init(){
    LOG_DIR="$1"
    if ! [ -d "${LOG_DIR}" ] && ! mkdir -p "${LOG_DIR}" 
    then
        echo 'Error: log directory set error.'
        return 1
    fi 
    
    LOG_NAME="$2"
    [ -z "$LOG_NAME" ] && { echo "Error: log file name not set." >&2; return 1; }
    LOG_FILE="${LOG_DIR}""/""${LOG_NAME}"".log"
    LOG_FILE_WF="${LOG_DIR}""/""${LOG_NAME}"".wf.log"

    LOG_ID=$(date '+%s')"_"$$

    [[ "1" != "${3}" ]] && [[ "2" != "${3}" ]] && [[ "4" != "${3}" ]] \
        && [[ "8" != "${3}" ]] && [[ "16" -ne "${3}" ]] && [[ "" != "${3}" ]] \
        && { echo "Error: log level (write to log file) set invalid." >&2; return 1; }
    LOG_FILE_LEVEL="$3"

    [[ "1" != "${4}" ]] && [[ "2" != "${4}" ]] && [[ "4" != "${4}" ]] \
        && [[ 8 != "${4}" ]] && [ 16 != "${4}" ]] && [[ "" != "${4}" ]] \
        && { echo "Error: log level (output to terminal) set invalid." >&2; return 1; }
    LOG_TERM_LEVEL="$4"

    return 0
}

##! @TODO : write debug log.
function log_debug(){
    log_write "${LOG_LEVEL_DEBUG}" "${LOG_DEBUG_STR}" "$1" "$2" "$3"
} 

##! @TODO : write trace log.
function log_trace(){
    log_write "${LOG_LEVEL_TRACE}" "${LOG_TRACE_STR}" "$1" "$2" "$3"
}

##! @TODO : write notice log.
function log_notice(){
    log_write "${LOG_LEVEL_NOTICE}" "${LOG_NOTICE_STR}" "$1" "$2" "$3"
}

##! @TODO : write warning log.
function log_warning(){
    log_write "${LOG_LEVEL_WARNING}" "${LOG_WARNING_STR}" "$1" "$2" "$3"
}

##! @TODO : write fatal log.
function log_fatal(){
    #fatal 级别日志打印到标准错误
    log_write "${LOG_LEVEL_FATAL}" "${LOG_FATAL_STR}" "$1" "$2" "$3" >&2
}

##! @TODO : write log，比较当前日志级别和初始化设置的日志级别，判断是否写入日志文件和打印至终端。
##! 如果初始化时，未设置日志级别，则不打印
##! @IN : $1 => log level
##! @IN : $2 => log level string to print
##! @IN : $3 => script file which running 
##! @IN : $4 => code line where write this log
##! @IN : $5 => log info which user define
function log_write(){
    local l_level="$1"
    local l_level_str="$2"
    local script_file="$3"
    local code_line_no="$4"
    local format_info="$5"
    
    # log format：
    # [日志级别标识]: [log ID]: 当前时间: 当前执行的脚本文件: 打印日志的代码的行数: 用户自定义信息
    local log_str="[${l_level_str}]: logid[${LOG_ID}]:"" $(date "+%Y-%m-%d %H:%M:%S")"" ${script_file}"" ${code_line_no}:"
    log_str="$log_str"" $(eval printf ${format_info})"

    # 判断日志级别，如果需要，写入到日志文件
    if [ -n "${LOG_FILE_LEVEL}" ] && [ ${l_level} -le "${LOG_FILE_LEVEL}" ] 
    then
        if [ ${l_level} -le 2 ]
        then
            echo "${log_str}" >> ${LOG_FILE_WF}
        else
            echo "${log_str}" >> ${LOG_FILE}
        fi
    fi
    
    # 判断日志级别，如果需要，则打印到终端
    [ -n "${LOG_TERM_LEVEL}" ] && [ ${l_level} -le ${LOG_TERM_LEVEL} ] && echo "${log_str}"

    return 0
}