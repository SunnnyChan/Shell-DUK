## INI config file parse library for Shell
Shell 的 ini 配置文件解析库，即使用方法。

>bash不支持多维数组，低版本的bash不支持关联数组（4.0 以上版本才支持），这对数据的处理带来了复杂性。

**Usage**  
本文以 ini 配置文件为例，采用一种变通的方法，来解析 ini，并保存至数组。

以下 ini 文件为例，文件名 test.ini：
```ini
[php]
dir="php"
port=""
need_sync=1

[mysql]
dir="mysql"
port="3306"
need_sync=0
type="server"
```

- **索引数组**  

***第一步***  

把 文件 解析成下面的格式，以与 Shell 数组的定义方法 array=(elem1 elem2) 相适应。
```ini
php
need_sync dir port
1 "php" ""
mysql
need_sync dir type port
0 "mysql" "server" "3306"
```

具体代码请参考[iniConfig.sh](iniConfig.sh) 中的 parseIniConfig 函数。

***第二步***  
保存配置信息至数组，思路是，为每一个 ini 文件中的 section 分配一个 index（我们就采用从0开始，按序分配）。  

然后 把所有 section 名 保存在一个数组（代码中的 ARR_INI_SECTION_NAME）中，数组元素的key为index值，value为 section 名。  

然后为每一个section 分配两个数组（ARR_INI_SECTION_KEY_${INI_SECTION_INDEX}、ARR_INI_SECTION_VALUE_${INI_SECTION_INDEX}），
数组名后缀为 index，分别保存 section 中配置项名和值，两个数组中同一个索引对应的配置项和值也是对应的。  

有了这样的映射关系，就可以访问相应的元素了。  

具体代码请参考[iniConfig.sh](iniConfig.sh) 中的 iniConf2Array 函数。

调用 iniConf2Array 会得到以下输出 ：   
```ini
ARR_INI_SECTION_KEY_0=([0]="need_sync" [1]="dir" [2]="port")
ARR_INI_SECTION_KEY_1=([0]="need_sync" [1]="dir" [2]="type" [3]="port")
ARR_INI_SECTION_NAME=([0]="php" [1]="mysql")
ARR_INI_SECTION_VALUE_0=([0]="1" [1]="php" [2]="")
ARR_INI_SECTION_VALUE_1=([0]="0" [1]="mysql" [2]="server" [3]="3306")
```

INI_SECTION_INDEX 记录section的最大索引值，方便后续遍历。  
注意:  
以上变量都需要定义为全局变量（Shell函数中的return返回机制是不能返回数组类型的），以可以让脚本中其它代码访问。

***最后我们来看下，怎么去访问？***  
总体思路就是，先反向查找响应的 index，再从相应的数组中，找到需要的值。  
因此，先实现一个反向查找index的函数：  

具体代码请参考[iniConfig.sh](iniConfig.sh) 中的 getIndexByValueFromArr 函数。

实现获取每个 section 中的 port 值：

```sh
iniConf2Array "test.ini"
for ((i = 0; i <= ${INI_SECTION_INDEX}; i++))
do
    section_name=${ARR_INI_SECTION_NAME[$i]}
    eval "arr_values=\${ARR_INI_SECTION_KEY_$i[@]}"
    arr_values=($(echo $arr_values))
    if index=$(getIndexByValueFromArr "${arr_values[*]}" "port")
    then
        eval "config_key=\${ARR_INI_SECTION_KEY_$i[index]}"
        eval "config_value=\${ARR_INI_SECTION_VALUE_$i[index]}"
        echo ${section_name} ${config_key} ${config_value}
    else
        log_fatal "${BASH_SOURCE[0]}" "$LINENO" "port not set in ini file'"
    fi
done
```
还可以将上面的这段获取配置值的代码封装为函数，方便调用：  
具体代码请参考[iniConfig.sh](iniConfig.sh) 中的 getValueBySectionNameAndKey 函数。

执行&输出：  
```sh
$ sh test.sh
php port
mysql port 3306
```
当然，如果你的 ini 文件 section name 可以作为变量名的一部分，而且在整个ini 文件中是唯一存在的，就可以这样定义数组：  
>ARR_INI_SECTION_KEY_${section_name}  

这样的好处是，可以减少一次索引。  

- **关联数组**
> 如果环境中的bash版本支持关联数组（可以使用 echo ${BASH_VERSION} 查看），就可以这样定义函数：  

具体代码请参考[iniConfig.sh](iniConfig.sh) 中的 iniConf2AssociativeArray 函数。

之前没使用过Shell的关联数组，这次特意安装了bash 4.2 版本做测试。  
经过测试：
关联数组需要显式的用 declare -A 来声明，才能使用。  

另外，在函数中定义的关联数组是局部变量，函数调用完毕就失效了。这与我们的需求在全局环境中保存这个数组冲突。  

目前我找到的方法是，在全局环境中，首先定义好相应的关联数组。  
```sh
declare -A ARR_INI_CONFIG_KV_php
declare -A ARR_INI_CONFIG_KV_mysql
```
然后再调用函数才能把 配置信息保存至全局数组中  
（这样写的坏处是，没有办法封装成函数，在用到这个功能时，都要在脚本中写一遍上述代码）。  

当然，上述代码可以写成，从配置文件中获取section_name，再用循环结构去定义，减少程序的硬编码。