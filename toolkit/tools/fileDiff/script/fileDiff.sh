#! /bin/bash -x
# fileDiff : use for diff tow files or two directory
# by sunnnychan@gmail.com
# version : v1.0.0
# 2015/11/18

#------------- global variable ------------------
VERSION="1.0.0"
SCRIPT_HOME=$( (cd "`dirname $0`"; cd ..; pwd) )
PROGRAM_HOME="${SCRIPT_HOME}/../.."
PROGRAM=$(basename $0 .sh)
PRO_LIB_DIR="${SCRIPT_HOME}/lib"
PRO_SCRIPT_DIR="${SCRIPT_HOME}/script"
PRO_CONF_DIR="${SCRIPT_HOME}/conf"
PRO_LOG_DIR="${PROGRAM_HOME}/log"
PRO_REPORT_DIR="${PROGRAM_HOME}/report"

#------------- script -------------------------
SCRIPT_DIFF2HTML="${PRO_SCRIPT_DIR}/diff2html"

#------------- initialize ----------------------
# initalize run-time env
source "${PRO_LIB_DIR}/initEnv.sh"
# load lib 
source "${PRO_LIB_DIR}/logLib.sh"
source "${PRO_LIB_DIR}/printLib.sh"
source "${PRO_LIB_DIR}/utility.sh"
source "${PRO_LIB_DIR}/diff.sh"
# set log configuration
log_init "${PRO_LOG_DIR}" "${PROGRAM}" "16" "16"

#---------- load program configuration -------
source "${PRO_CONF_DIR}/fileDiff.conf"
DIFF_EXCLUDE_LIST="${PRO_CONF_DIR}/diffExclude.list"

#------------ function -----------------------
function printUsage() {
cat << EOF
Usage : 
    sh $0 [file1] [file2]
    sh $0 [directory1] [directory2]
EOF
return 0
}
#------------ main flow -----------------------
if [[ "$#" != "1" ]] && [[ "$#" != "2" ]] && [[ "$#" != "3" ]]
then
    log_fatal "${BASH_SOURCE[0]}" "$LINENO" "'Unrecongnized parameter.'"
    printUsage 
    exit 1
fi

if [[ "$#" = "1" ]] || [[ "$#" = "3" ]] 
then
    case "X$1" in
        X-h|"X-?"|X--help) 
            printUsage
            exit 0
            ;;
        X-v|X--version) 
            printVersion
            exit 0
            ;;
        X-1) diff2DirStdDir1 "$2" "$3"
            exit $?
            ;;
        X-2) diff2DirStdDir2 "$2" "$3"
            exit $?
            ;;
        X-*)
            log_fatal "${BASH_SOURCE[0]}" "$LINENO" "'Unrecongnized options : '${1}"
            printUsage
            exit 1
            ;;
        X*)
            log_fatal "${BASH_SOURCE[0]}" "$LINENO" "'Unrecongnized parameter : '${1}"
            printVersion
            exit 1
            ;;
    esac
fi

if [[ "$#" = "2" ]] 
then 
    if [ -f $1 ] && [ -f $2 ]
    then
        log_notice "${BASH_SOURCE[0]}" "$LINENO" "'diff two files. \n%s \n%s ' $1 $2 "
        diff2Files "$1" "$2"      
    else 
        if [ -d $1 ] && [ -d $2 ]
        then 
            log_notice "${BASH_SOURCE[0]}" "$LINENO" "'diff two directory. \n%s \n%s ' $1 $2 "
            diff2Dirs "$1" "$2"
        else
            log_fatal "${BASH_SOURCE[0]}" "$LINENO" "'parameter must be two files or directorys. [%s] [%s]' $1 $2"
            exit 1
        fi
    fi
fi

