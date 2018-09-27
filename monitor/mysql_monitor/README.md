
## mysql_monitor
统计MySQL服务器状态，包括 查询、链接、Innodb行锁、SQL执行状态。

> [mysql_monitor.sh](https://github.com/SunnnyChan/shell-utilities/blob/master/monitor/mysql_monitor/mysql_monitor.sh)

#### 用法及输出解析：

![](https://github.com/SunnnyChan/shell-utilities/blob/master/monitor/mysql_monitor/mysql_monitor_1.png)

上图打印的是从 mysqladmin extended-status 获取的一些关键信息，取样的时间为1s。  
一开始的5列是事务和SQL请求相关的统计：  
分别是过去1s 完成的事务、Select、Insert、Update数目以及总的请求数。

接下来两列是链接相关统计，对应于 mysqladmin extended_status 中的 Threads_Connected、Threads_Running。

 > *Threads_Connected* : The number of currently open connections.  
 > *Threads_Running* : The number of threads that are not sleeping.

最后5列是Innodb锁相关的统计，分别为 当前等待锁的事务数，过去1s锁定的总时长，平均等待时间，最长一次等待的时间，过去1s发生等待的总数。  

Total_Time 和 Total_waits 两列 mysqladmin extended-status  原来的统计是系统启动到现在的总数据，脚本变更为了过去1s的统计数据，更有意义一些。  

![](https://github.com/SunnnyChan/shell-utilities/blob/master/monitor/mysql_monitor/mysql_monitor_2.png)

上图打印的是从 mysqladmin processlist 获取的查询请求执行状态信息，过滤了无状态的线程和主从同步线程。

