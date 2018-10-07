# create by sunnnychan@gmail.com
# 2015/11/18

IFS=$' \n\t'

UMASK=022
umask ${UMASK}

unset -f unalias
\unalias -a

unset -f command

#Ensure "/usr/bin:/bin" in fornt of PATH
SYSPATH="$(command -p getconf PATH 2>/dev/null)"
if [ -z "${SYSPATH}" ];then
  SYSPATH="${BIN_ROOT}:/usr/bin:/bin"
fi
PATH="${BIN_ROOT}:${SYSPATH}:$PATH"
