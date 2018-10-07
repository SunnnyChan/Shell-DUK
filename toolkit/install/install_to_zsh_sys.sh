#! /bin/bash -
##! @File    : install_to_sys.sh
##! @Date    : 2016/04/22
##! @Author  : chenguang02@baidu.com
##! @Version : 1.0
##! @Todo    : 
##! @FileOut : 

SH_HOME="$(cd $(dirname  ${BASH_SOURCE[0]})/..; pwd)"
source "${SH_HOME}/lib/frame/main.sh"

#
INSATLL_TOOLS_DIR="${INSTALL_ROOT}/tools"
INSATLL_TOOLS_LIST="
${INSATLL_TOOLS_DIR}/install_tmux.sh 
"
for install_script in ${INSATLL_TOOLS_LIST}
do
    bash ${install_script}
done

SET_ENV_SCRIPT="${INSTALL_ROOT}/set_env.sh"
STRING_WIRTE_TO_BASHRC="source ${SET_ENV_SCRIPT}"
BASHRC_FILE="$(cd ; pwd)/.zshrc"
# 
if ! grep -E "source[ ]*${SET_ENV_SCRIPT}" "${BASHRC_FILE}" 2>/dev/null 1>&2
then
    echo "${STRING_WIRTE_TO_BASHRC}" >> "${BASHRC_FILE}"
fi

echo "Install Successfully."

##! vim: ts=4 sw=4 sts=4 tw=100 ft=sh 
