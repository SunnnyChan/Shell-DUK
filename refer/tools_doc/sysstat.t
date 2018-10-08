http://sebastien.godard.pagesperso-orange.fr/documentation.html

https://github.com/sysstat/sysstat

# mpstat -P ALL 2 3
# mpstat -I ALL 2 3
# mpstat -A



Introduction to sysstat

Sysstat的功能列表：

iostat：统计并报告你的设备的CPU状态和I/O状态数据。
mpstat：监控和显示关于CPU的细节信息。
pidstat：统计正在运行的进程/任务的CPU、内存等信息。
sar：保存和报告不同资源（CPU、内存、输入输出、网络、内核等）的详细信息。
sadc：系统活动数据收集器，用于为sar收集后台的数据。
sa1：读取和存储sadc的数据文件的二进制数据。
sa2：和sar协作，用于总结每日报告。
Sadf：以不同的格式（CSV或XML）显示sar生成的数据。
Sysstat：解释sysstat的各种作用。
nfsiostat-sysstat:统计NFS协议的网络文件系统的 I/O状态数据。
cifsiostat：统计CIFS协议的网络文件系统的 I/O状态数据。

The sysstat package contains utilities to monitor system performance and usage activity. Sysstat contains various utilities, common to many commercial Unixes, and tools you can schedule via cron to collect and historize performance and activity data
iostat(1) reports CPU statistics and input/output statistics for devices, partitions and network filesystems.
mpstat(1) reports individual or combined processor related statistics.
pidstat(1) reports statistics for Linux tasks (processes) : I/O, CPU, memory, etc.
sar(1) collects, reports and saves system activity information (CPU, memory, disks, interrupts, network interfaces, TTY, kernel tables,etc.)
sadc(8) is the system activity data collector, used as a backend for sar.
sa1(8) collects and stores binary data in the system activity daily data file. It is a front end to sadc designed to be run from cron.
sa2(8) writes a summarized daily activity report. It is a front end to sar designed to be run from cron.
sadf(1) displays data collected by sar in multiple formats (CSV, XML, JSON, etc.). This command can also be used to draw graphs for the various activities collected by sar using SVG (Scalable Vector Graphics) format.
tapestat(1) reports statistics for tape drives connected to the system.
sysstat(5) is just a manual page for sysstat configuration file, giving the meaning of environment variables used by sysstat commands.
cifsiostat(1) reports CIFS statistics.
Go to the Features page to display a list of sysstat's main features, and to the Matrix of activities to list all the possible activities for sar and corresponding options to use with sar and sadc.
And if you don't find here what you are looking for, try out Qwant , the new search engine that respects your privacy...!
Installation of sysstat:

Compile and install sysstat by running the following commands:

$ ./configure
$ make
$ su
<enter root password>
# make install
Note: With older versions of sysstat that don't support autoconf (up to v7.0.4), configuring sysstat was done with "make config" instead of "./configure".

Command explanations: 
./configure: Runs the auto-configuration process. This script attempts to guess correct values for various system-dependent variables used during compilation.  It uses those values to create a "Makefile" in the current directory.
You can give "configure" values for configuration parameters. For example, you can set the installation directory with the "--prefix" parameter. The following example shows how to set the installation directory to /usr (instead of the default value /usr/local):

$ ./configure --prefix=/usr

Enter "./configure --help" to display all the available parameters.
Note: Instead of running "./configure", you can run "iconfig", the Interactive Configuration script. This is a front-end to "configure". It will prompt you for various parameters values used by "configure".

make: Compiles sysstat from sources. The various commands are then available.
make install: Installs sysstat binaries, and even create a crontab to start collecting data automatically if requested to do so at config stage. 
Configuring sysstat:

Cron information: 
To begin gathering sysstat history information, you must add to, or create a privileged user's crontab. The default history data location is /var/log/sa. The user running sysstat utilities via cron must have write access to this location.  
Below is an example of what to install in the crontab "sysstat" located in /etc/cron.d directory and using Vixie cron syntax. Adjust the parameters to suit your needs. Use man sa1 and man sa2 for information about the commands.

# Run system activity accounting tool every 10 minutes
*/10 * * * * root /usr/lib/sa/sa1 1 1
# 0 * * * * root /usr/lib/sa/sa1 600 6 &
# Generate a daily summary of process accounting at 23:53
53 23 * * * root /usr/lib/sa/sa2 -A

Each day a file will be created in the /var/log/sa directory. 
Startup script information:

At system startup, a LINUX RESTART message must be inserted in the daily data file to tell sar that the kernel counters have been reinitialized. Here is a sample sysstat bootscript used to accomplish this:

$ cat > /etc/rc.d/init.d/sysstat << "EOF"
#!/bin/sh
# Begin $rc_base/init.d/sysstat

# Based on sysklogd script from LFS-3.1 and earlier.
# Rewritten by Gerard Beekmans  - gerard@linuxfromscratch.org

. /etc/sysconfig/rc
. $rc_functions

case "$1" in
        start)
                echo "Calling the system activity data collector (sadc)..."
                /usr/lib/sa/sadc -F -L -
                evaluate_retval
                ;;
        *)
   
                echo "Usage: $0 start"
               exit 1
                ;;
esac

# End $rc_base/init.d/sysstat
EOF
$ chmod 754 /etc/rc.d/init.d/sysstat

The sysstat bootscript only needs to run at system startup, therefore only one symlink is required. Create this symlink in /etc/rc.d/rcsysinit.d using the following command:

# ln -sf ../init.d/sysstat /etc/rc.d/rcsysinit.d/S85sysstat
If you are using systemd, then a service file is used instead of the bootscript and symlink above. Here is a sample service file (put it in your systemd service directory):

# /usr/lib/systemd/system/sysstat.service
# (C) 2012 Peter Schiffer (pschiffe <at> redhat.com)
#
# sysstat-10.1.7 systemd unit file:
#     Insert a dummy record in current daily data file.
#     This indicates that the counters have restarted from 0.

[Unit]
Description=Resets System Activity Logs

[Service]
Type=oneshot
RemainAfterExit=yes
User=root
ExecStart=/usr/local/lib64/sa/sa1 --boot

[Install]
WantedBy=multi-user.target


Now the good news: The above crontab, startup script and link or systemd service file may be automatically created and installed for you when you enter "make install", providing that you have set configure's  option "--enable-install-cron" during configuration stage:

$ ./configure --enable-install-cron
