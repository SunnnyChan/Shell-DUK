#! /bin/bash -
##! @File    : install_tmux.sh
##! @Date    : 2016/06/12
##! @Author  : sunnnychan@gmail.com
##! @Version : 1.0
##! @Todo    : 
##! @FileOut : 
##! @Brief   : 

SH_HOME="$(cd $(dirname  ${BASH_SOURCE[0]})/../..; pwd)"
source "${SH_HOME}/lib/frame/main.sh"

TMUX_CONF="${INSTALL_ROOT}/confs/sys/tmux"

cd ${HOME} && rm -rf .tmux && rm -f .tmux.conf && cp -r ${TMUX_CONF} .tmux\
    && ln -s .tmux/tmux.conf .tmux.conf && ln -s .tmux/tmux.conf.local .tmux.conf.local

##! vim: ts=4 sw=4 sts=4 tw=100 ft=sh 
