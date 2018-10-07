text {
    # output with number line
    cat -n file.t 或 nl file.t
}

process {
    #进程456打开的文件
    lsof -p 456,123 
}

network {
    #IPv6协议的网络文件。
    lsof -i 4
    #没有ssh的情况下传输文件，配合tar真心好用
    nc 
}

file or directory {
    #仅列出当前目录下所有的一级子目录
    ls -d */ 或 find -type d -maxdepth 1
    #快速备份文件
    cp filename{,.bak}
}

ouput {
    #让输出更易读
    df | column -t
}

command {
    #替换上一条命令中的第一个匹配，并执行
    ^an^ount^
}

code { 
    #将读取到的元素存入数组
    read -a
}

