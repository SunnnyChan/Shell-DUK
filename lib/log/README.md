## Log for Shell
Shell 的 日志库。

> [log.sh](log.sh)

> Shell的库都比较少见，一直希望整理一份自己常用的Shell库，先从日志开始。  
在功能比较复杂，代码行较多的脚本中，良好的日志能使定位问题事半功倍。 

**功能**  
- 1.格式化输出日志，日志行打印级别、时间、执行的脚本名、代码行、用户自动定义信息，方便问题定位和跟踪。  
- 2.按级别输出日志，支持五个级别的日志输出。
- 3.支持输出到终端、日志文件，这两种方式都支持按照级别输出，如只想把fatal日志打印到终端。

**Usage**

怎么使用上面的库？  
例如 我需要写一个test.sh脚本  

首先加载日志库
```shell
source 'log.sh'
``` 
初始化日志：  
```shell
log_init "/home/users/test" "test" "8" "2"
```
写日志：
```shell
log_trace "$0" "$LINENO" "'this line is trace log: %s' 'test log'"
log_warning "$0" "$LINENO" "'this line is trace log: %s' 'test log'"
```
*参数一：*  
$0 表示当前执行的脚本  

注意：如果test.sh还调用了其他脚本，例如 source 了一个 functions.sh，  
在functions.sh这个脚本中也需要写日志，这时第一个参数我们肯定希望写入“functions.sh”。  

但使用 $0 ，得到的还是 test.sh ，这时你需要使用环境变量 ${BASH_SOURCE[0]} 。  
兼容两种情况的写法就是，${BASH_SOURCE[0]-$0}（当然这里运行的环境是bash）。

*参数二：*  
$LINENO 表示当前执行的代码行，这两个参数只传这两个值即可。  

*参数三：*  
 `"'this line is trace log: %s' 'test log'"`   
 作为第三个参数，采用的格式是C语言printf函数使用的格式，不过参数以空格分隔。  

注意：  
由于Shell传参的原因，第三个参数的一定要以单引号包含起来，里面的格式化输出字符串，以及参数要以双引号包含起来，并且之间以空格分隔。

> 最终写入到日志文件或终端的日志信息为：  

  [TRACE]: logid[1437385728_18020]: 2015-07-20 17:48:48 test_log.sh 6:this line is trace log: test log  
  [WARNING]: logid[1437385728_18020]: 2015-07-20 17:48:48 test_log.sh 7:this line is trace log: test log  

> 结束之前有一点需要提醒：  

由于在Shell中，除了在function 中以local关键字申明的变量外（有些语句结构也是，如for等）其它都是全局变量，  
所以在编写自己的脚本时，变量名要区别于库文件中的变量，一个比较好的方法的给变量加上一致的前缀或者后缀。
