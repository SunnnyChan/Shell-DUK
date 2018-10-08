
# Shell Utilities

## *Synopsis*

> ***CMD***  
Shell command, improve working efficiency in Linux, MacOS.  

> ***Utils***  
Shell script tools, solve some practical scenario problems.

## *Content*
- [create_trust_relationship](#create_trust_relationship)  
- [mysql_monitor](#mysql_monitor)

## *DESCRIPTION*

### Usage 
Get Code, then add bin directory to your $PATH. 
```shell
  export PATH="$PATH:/home/username/shell.utils/bin"
```

### CMD
These tools can be use as CMD.  

**List :**
- ##### [create_trust_relationship](cmd/create_trust_relationship.sh) 
  > create trust relationship between local host and remote host.
  > usage :
  ```shell
  ./create_trust_relationship.sh [remote hostname or ip] [username]
  ```

### Utils
#### Mointor
- ##### [mysql_monitor](tools/sys_monitor/mysql_monitor/README.md) 
> 统计MySQL服务器状态，包括 查询、链接、Innodb行锁、SQL执行状态。


