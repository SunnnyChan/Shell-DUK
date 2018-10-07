LOAD_SHELL_LIB_FILE_PATH=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)

function loadShLib(){
    local LIB_FILES="logLib.sh printLib.sh utility.sh"
    [ -n "$1" ] && LIB_FILES="$1"
    for libFile in $LIB_FILES
    do
        local libFilePath="${LOAD_SHELL_LIB_FILE_PATH}/${libFile}"
        if [ -f "${libFilePath}" ]
        then
            source "${libFilePath}"
        else
            echo "Error: Shell library file [${libFilePath} not exist.]"
            exit 1
        fi
    done
}
loadShLib

unset LOAD_SHELL_LIB_FILE_PATH
##! vim: ts=4 sw=4 sts=4 tw=100 ft=sh
