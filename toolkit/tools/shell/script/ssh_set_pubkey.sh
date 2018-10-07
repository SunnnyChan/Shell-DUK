#! /bin/sh -
# ssh_set_pubkey.sh : generate publice and private key,
#    and snyc publice key to remote server
# USAGE : ssh_set_pubkey.sh [-?|-h|--help]
#                           [-v|--version]
#                           [-u|--user]
#                           [-n|--host]
#
# by chenguang02@baidu.com
# 2014/01/05


#-----script initinizle
IFS=$' \n\t'
#PATH="/usr/bin:/bin:/usr/local/bin"
#export PATH

UMASK=022
umask ${UMASK}

unset -f unalias
\unalias -a

unset -f command

#Ensure "/usr/bin:/bin" in fornt of PATH
SYSPATH="$(command -p getconf PATH 2>/dev/null)"
if [ -z "${SYSPATH}" ];then
  SYSPATH="/usr/bin:/bin"
fi
PATH="${SYSPATH}:$PATH"

#Reset PATH,set PATH="/usr/bin:/bin:/usr/local/bin"
#PATH="/usr/bin:/bin:/usr/local/bin"
#export PATH

#----functions

error()
{
  echo "$@" 1>&2
  usage_and_exit 1
}

usage()
{
  cat <<EOF
Usage:
       $PROGRAM [-?|-h|--help]
                [-v|--version]
                [-u|--user]
                [-n|--hostname]
EOF
}

usage_and_exit()
{
  usage
  exit $1
}

version()
{
  echo "$PROGRAM version $VERSION"
}

#----global variable declare
VERSION="v1.0 2014/01/05"
PROGRAM="`basename $0`"
CURR_USER_HOME="`(cd ~;pwd)`"

sleep 1
DATE_TIME=`date "+%Y%m%d_%H%M%S"`

USER=
HOSTNAME=

SSH="ssh"
SSH_KEY_GEN="ssh-keygen"
SSH_KEY_SYNC="ssh-copy-id"

ENCRYPTION_TYPE="rsa"
PRIVATE_KEY_FILE="${CURR_USER_HOME}/.ssh/id_rsa"
PUBLIC_KEY_FILE="${CURR_USER_HOME}/.ssh/id_rsa.pub"

#----main workflow
while [ $# -gt 0 ]
do
  case $1 in
  '-?'|-h|--help)
     usage_and_exit
     ;;
  -v|--version)
     version
     exit 0
     ;;
  -u|--user)
     USER=$2
     shift 1
     ;;
  -n|--hostname)
     HOSTNAME=$2
     shift
     ;;
  -*)
     error "Unrecognized option : $1"
     ;;
  *)
     break
     ;;
  esac
  shift 1
done

[ -z ${USER} ] &&  error "Unspecified user !"
[ -h ${HOSTNAME} ] &&  error "Unspecified hostname !"


#generate key and sync to server
if [ -f "${PRIVATE_KEY_FILE}" ]
then
  mv "${PRIVATE_KEY_FILE}" "${PRIVATE_KEY_FILE}_${DATE_TIME}"
fi

if [ -f "${PUBLIC_KEY_FILE}" ]
then
  mv "${PUBLIC_KEY_FILE}" "${PUBLIC_KEY_FILE}_${DATE_TIME}"
fi

${SSH_KEY_GEN} -t ${ENCRYPTION_TYPE}  -N "" -f ${PRIVATE_KEY_FILE} > /dev/null

if  which "$SSH_KEY_SYNC"   >/dev/null 2>&1
then
  ${SSH_KEY_SYNC} -i ${PUBLIC_KEY_FILE} ${USER}@${HOSTNAME}
else
  ${SSH} ${USER}@${HOSTNAME} "mkdir -p ~/.ssh/; chmod 700 ~/.ssh/; cat >> ~/.ssh/authorized_keys ; chmod 700  ~/.ssh/authorized_keys" < $PUBLIC_KEY_FILE >/dev/null 2>&1
fi
