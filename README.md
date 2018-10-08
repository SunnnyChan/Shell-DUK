
# Shell Utilities

## *Synopsis*
Shell common tools for rapid application.
Include basic build-in CMD, script CMD and script for practical scenario problems.

## *Content*
- [create_trust_relationship](#create_trust_relationship)  

- [mysql_monitor](#mysql_monitor)

## *Install* 
```md
Get Code, then add bin directory to your $PATH. 
```
```shell
  export PATH="$PATH:/home/username/shell.utils/bin"
```

## *DESCRIPTION*

### CMD
> Shell command, improve working efficiency in Linux, MacOS.
* ##### [Basic build-in CMD](refer/)

* ##### [create_trust_relationship](cmd/create_trust_relationship.sh) 
  > create trust relationship between local host and remote host.
  > usage :
  ```shell
  ./create_trust_relationship.sh [remote hostname or ip] [username]
  ```

### Utils
> Shell script tools, solve practical scenario problems.
#### Mointor
* ##### [mysql_monitor](tools/sys_monitor/mysql_monitor/README.md) 
> 统计MySQL服务器状态，包括 查询、链接、Innodb行锁、SQL执行状态。


