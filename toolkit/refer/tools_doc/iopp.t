iotop对内核及python版本都有一定要求，有时候无法用上，这时候就可以使用iopp作为替代方案。
在有些情况下可能无法顺利使用iotop，这时候就可以选择iopp了。
它的作者是Mark Wong，用C开发，代码仅有532行，非常简洁。

usage: iopp -h|--help
usage: iopp [-ci] [-k|-m] [delay [count]]
            -c, --command display full command line
            -h, --help display help
            -i, --idle hides idle processes
            -k, --kilobytes display data in kilobytes
            -m, --megabytes display data in megabytes
            -u, --human-readable display data in kilo-, mega-, or giga-bytes


ouput:
pid 进程ID
rchar 预计发生磁盘读的字节数
wchar 预计发生磁盘写的字节数
syscr I/O读次数
syscw I/O写此书
rbytes 真正发生磁盘读的字节数
wbytes 真正发生磁盘写的字节数
cwbytes 因为清空页面缓存而导致没有发生操作的字节数
command 命令行名称

