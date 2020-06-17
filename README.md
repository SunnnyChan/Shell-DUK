
# 👉 Shell-DUK (Shell Development and Utility Kits)
[![License](https://img.shields.io/badge/license-Apache%202-4EB1BA.svg)](https://www.apache.org/licenses/LICENSE-2.0.html)

## ✨ Shell command, improve working efficiency in Linux, MacOS

Shell common tools for rapid application.  
Include basic build-in CMD, script CMD and script for practical scenario problems.

### 🔰 *Install*  

```bash
# for bash environment :
sh install/install_to_bash_sys.sh 
```
```bash
# for zsh environment :
sh install/install_to_zsh_sys.sh 
```

### 📚 *DESCRIPTION*

#### [Basic build-in CMD](refer/cmd_doc/cmdCollection.md)
#### [Quick Command Line](refer/cmd_doc/quickCmdLine.md)

#### Script Command Line

##### genScpPath - 生成Scp命令行Copy参数
##### grepSoPath - 查找动态库文件位置
##### backupFile - 快速备份文件
##### grepPhpClass - 查找PHP类定义文件
##### searchMarco - 查找C语言宏定义

##### [create_trust_relationship](cmd/create_trust_relationship.sh)  
```bash
create trust relationship between local host and remote host.  
      usage :   
      create_trust_relationship [remote hostname or ip] [username]
```

## 🐚 Shell script tools, solve practical scenario problems

### [mysql_monitor - 统计MySQL服务器状态](tools/sys_monitor/mysql_monitor/README.md)   
### [third-party tools integrate](refer/tools_doc/README.md)
#### [Todo](refer/todo/tools_collection.md)

## 💖 Shell Script Development
### [Framework - Improve Shell script development efficiency](refer/dev/DevFramework.md) 

### Shell Library
####  [Log](lib/log)
####  [INI Config](lib/config/ini)
