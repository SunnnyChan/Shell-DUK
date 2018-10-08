
# Shell Tools Kit

## *Synopsis*
Shell common tools for rapid application.  
Include basic build-in CMD, script CMD and script for practical scenario problems.

## *Install* 
```md
for bash environment :
```
```sh
  sh install/install_to_bash_sys.sh 
```
```md
for zsh environment :
```
```sh
  sh install/install_to_zsh_sys.sh 
```

## *DESCRIPTION*

### CMD
> Shell command, improve working efficiency in Linux, MacOS.
* ##### [Basic build-in CMD](refer/cmd_doc/cmdCollection.md)
* ##### [Quick Command Line](refer/cmd_doc/quickCmdLine.md)
* ##### Script Command Line
> *  genScpPath - 生成Scp命令行Copy参数
> * grepSoPath - 查找动态库文件位置
> * backupFile - 快速备份文件
> * grepPhpClass - 查找PHP类定义文件
> * searchMarco - 查找C语言宏定义
> * [create_trust_relationship](cmd/create_trust_relationship.sh)  
create trust relationship between local host and remote host.  
      usage :   
      create_trust_relationship [remote hostname or ip] [username]

### Utils
> Shell script tools, solve practical scenario problems.
* #####  Mointor
> * [mysql_monitor](tools/sys_monitor/mysql_monitor/README.md)   
统计MySQL服务器状态，包括 查询、链接、Innodb行锁、SQL执行状态。

* #####  [third-party tools](refer/tools_doc/README.md)
  >Integrate third-party tools
> * [todo](refer/todo/tools_collection.md)