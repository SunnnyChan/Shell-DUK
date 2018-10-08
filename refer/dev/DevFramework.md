# Shell Development Framework

## Project Frame
```md
bin
工具命令行

lib
lib/frame/main.sh 工具集框架
lib/frame/tls_shell.sh  shell脚本工具框架
lib/shell shell 通用函数库
lib/log/log.sh 日志库
lib/config/ini/iniConfig.sh ini配置文件解析库

log
log/shell shell 工具日志输出目录

tools
tools/shell shell 工具目录

install
install/install_to_sys.sh 
    安装脚本目录，提供安装脚本，将工具集中提供的工具直接安装到系统环境中，
    可以在系统环境中已命令行的方式直接执行。
```
## 开发流程
```md
1. 开发shell脚本工具，建议采用shell function 方式，在 bin 目录下建调用脚本的方式。

2. 调用脚本必须首先定义以下全局变量：
PROGRAME 默认使用脚本文件名，如果打日志文件，也同时是日志文件名。
VERSION 工具版本号

3. 然后加载框架脚本 lib/frame/tls_shell.sh
该脚本会 初始化 工具框架变量，执行环境，Shell库，以及初始化日志等。
```
> 当你需要开发一个工具只需要做的是把工具封装为函数，然后加载脚本，通过入口函数的方式调用即可。

## [开发实例](https://github.com/SunnnyChan/shell.utils)