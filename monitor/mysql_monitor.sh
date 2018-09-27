#! /bin/sh -
##! @TODO : 统计MySQL服务器状态，包括 查询、链接、Innodb行锁、SQL执行状态。
##! @VERSION : 1.0.0
##! @AUTHOR : SunnyChan sunny__chan@126.com
##! @FILEIN : mysql_monitor
##! @FILEOUT : log/status.log , log/processlist.log
##! @DATE : 2015/03/30

export PATH="/usr/bin:/bin"
PROGRAM=$( basename $0 )
VERSION="1.0.0"

MYSQL_ADMIN="/home/mysql/mysql_ins/bin/mysqladmin -uUser -pPasswd -P3306 -h127.0.0.1"

mkdir -p "log"
EXT_INFO_LOG="log/status.log"
PROC_INFO_LOG="log/processlist.log"
> ${EXT_INFO_LOG}
> ${PROC_INFO_LOG}

function usage(){
  echo "Usage : sh ${PROGRAM} [-e|-p]"
  echo " -e print info from mysqladmin extended_status."
  echo " -p print info from mysqladmin processlist."
}

##! @TODO : 打印查询计数、链接计数、Innodb行锁计数
function prt_ext_info(){
  ${MYSQL_ADMIN} ext -i 1 | 
    awk 'BEGIN{printf "%-7s %-7s %-7s %-7s %-7s %-1s %-9s %-7s %-1s %-10s %-10s %-8s %-8s %-11s\n",\
        "Commits","Selects","Inserts","Updates","Queries","|","Connected","Running","|",\
        "Curr_Waits","Total_Time","Avg_Time","Max_Time","Total_Waits";
        printf "%-43s %-21s %-20s\n"," ","[ Threads ]","[ Innodb_Row_Lock (time unit : ms) ]";
        is_first_line=1;
        qp = 0;
     }
     /Com_commit / { commits = $4 - last_commits; last_commits = $4 }
     /Com_select / { selects = $4 - last_selects; last_selects = $4 }
     /Com_insert / { inserts = $4 - last_inserts; last_inserts = $4 }
     /Com_update / { updates = $4 - last_updates; last_updates = $4 }
     /Queries/ { queries = $4 - last_queries; last_queries = $4; }
     /Innodb_row_lock_current_waits/ { row_lock_curr_waits = $4; }
     /Innodb_row_lock_time / { row_lock_total_time = $4 - last_total_time; last_total_time = $4; }
     /Innodb_row_lock_time_avg/ { row_lock_avg_time = $4; }
     /Innodb_row_lock_time_max/ { row_lock_avg_max = $4; }
     /Innodb_row_lock_waits/ { row_lock_total_waits = $4 - last_total_waits;last_total_waits = $4; }
     /Threads_connected/{ thr_conn = $4; }
             /Threads_running/{ 
        /* 因为打印的是取样时间内的变化值，由于第一行数据是总数，跳过 */
        if ( is_first_line )
            is_first_line = 0;
     else 
            printf "%-7d %-7d %-7d %-7d %-10d %-9d %-10d %-10d %-10d %-8d %-8d %-11d\n",\
            commits,selects,inserts,updates,queries,thr_conn,$4,\
            row_lock_curr_waits,row_lock_total_time,row_lock_avg_time,row_lock_avg_max,row_lock_total_waits;
     }
     {fflush();}' 
}

##! @TODO : 打印SQL执行状态
function prt_processlist()
{
  ${MYSQL_ADMIN} processlist -i 1 | 
    awk 'BEGIN{FS = "|"}
    { if ($0 ~ /Id.*State/){printf "\n" };
     /* 只打印有状态的链接，另外去掉了向从服务器同步binlog的链接 */
     if ($8 ~ /[a-zA-Z]/ && $8 !~ /binlog to slave/){ 
        split($9,arr_info," ");
        split($8,arr_state," ");
        printf "%-4s %-10s %-10s %-7s %-10s %-10s %-10s\n",\
        $2,arr_state[1],arr_state[2],arr_info[1],arr_info[2],arr_info[3],arr_info[4];
     }
     fflush();
    }'
}

#
if [[ "$1" = "-e" ]]
then
    prt_ext_info | tee -a ${EXT_INFO_LOG} 
fi

if [[ "$1" = "-p" ]]
then
    prt_processlist | tee -a ${PROC_INFO_LOG}
fi

if [[ "$1" = "-h" ]] || [[ "$1" = "-?" ]]
then
    usage
fi