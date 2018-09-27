
# Shell Utilities

## *Synopsis*
> ***CMD***  
Shell command, improve working efficiency in Linux, MacOS.  

> ***Utilities***  
Shell utility tools, solve some practical scenario problems.

> ***Library***  
Shell lib, improve Shell script development efficiency.

## *Content*
>**CMD**
- [create_trust_relationship](#1)  

> **Utilities**   

- [mysql_monitor](#2)

> **Library**  
- [Log](#3)
- [INI Config](#4)

## *DESCRIPTION*
### CMD
These tools can be use as CMD.  

**Usage :**  
Get Code, then add bin directory to your $PATH. 
```shell
  export PATH="$PATH:/home/username/shell-utilities/bin"
```

**List :**
- [create_trust_relationship](cmd/create_trust_relationship.sh) <span id="1"></span>
  
  > create trust relationship between local host and remote host.

  > usage :
  ```shell
  ./create_trust_relationship.sh [remote hostname or ip] [username]
  ```
### Utilities
#### Mointor
- [mysql_monitor](utils/monitor/mysql_monitor/README.md) <span id="2"></span>
> 统计MySQL服务器状态，包括 查询、链接、Innodb行锁、SQL执行状态。

### Library
- [Log](lib/log/README.md) <span id="3"></span>
> log lib for shell.

- [INI Config](lib/config/ini/README.md) <span id="4"></span>
> ini config file parse lib for shell.


