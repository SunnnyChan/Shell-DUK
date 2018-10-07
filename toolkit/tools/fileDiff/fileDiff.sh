#! /bin/sh -
# by chenguang02@baidu.com

ROOT="$(cd $(dirname ${BASH_SOURCE[0]});  pwd)"

cd ${ROOT} && sh "script/fileDiff.sh" $@
