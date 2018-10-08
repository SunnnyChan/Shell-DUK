```md
https://goaccess.io

NAME

goaccess - Fast web log analyzer and interactive viewer.

SYNOPSIS

goaccess -f log [-c][-r][-m][-h][-q][-d][-g][-a][-o csv|json][-e IP_ADDRESS][...]
DESCRIPTION

goaccess is a free (MIT Licensed) real-time web log analyzer and interactive viewer that runs in a terminal in *nix systems. It provides fast and valuable HTTP statistics for system administrators that require a visual server report on the fly. GoAccess parses the specified web log file and outputs the data to the X terminal. Features include:

General Statistics:Number of valid requests, number of invalid requests, time to analyze the data, unique visitors, unique requested files, unique static files (css, ico, jpg, js,swf, gif, png) unique HTTP referrers (URLs), unique 404s (not found), size of the parsed log file, bandwidth consumption.
Unique visitors: This panel is listed by day with dates included. HTTP requests possessing the same IP, the same date, and the same agent are considered as a unique visit. It includes web crawlers/spiders.
Requested files: Requested Files shows the most highly requested files on your web server. It shows hits, unique visitors, and percentage, along with the cumulative bandwidth, what protocol was used, and what request method was used. Optionally it can display the average time served.
Requested static files: Lists the most frequently static files such as: jpg, css, swf, js, gif, and png file types, with the same metrics as the last panel.
404 or Not Found: Listed like previous panels, containing the same metrics. This panel lists the top recurrent HTTP 404.
Hosts: This panel has detailed information on the hosts themselves. It displays the same metrics as previous panels, such as number of hits, visitors, cumulative bandwidth, and time served. This is great to spot aggressive crawlers and identifying who's eating your bandwidth. Expanding the panel can display more information like such as host's reverse DNS lookup result, country of origin and city. If the -a argument is enabled, a list of user agents can be displayed by selecting the desired IP address, and then pressing ENTER.
Operating Systems: This panel will list Host's operating system. It attempts to provide the most specific version of each operating system. Operating Systems are listed by type.
Browsers: This panel will list Host's browsers. It attempts to provide the most specific version of each browser Browsers are listed by type.
Visit Times: This panel will display an hourly report. This option displays 24 data points, one for each hour of the day.
Virtual Hosts: This panel will display all the different virtual hosts parsed from the access log. This panel is displayed if %v is used within the log-format string..
Referrers URLs: If the host in question accessed the site via another resource, or was linked/diverted to you from another host, the URL they were referred from will be provided here in this panel. (disabled by default)
Referring Sites: This panel will display only the host part but not the whole URL. The URL where the request came from.
Keyphrases: It reports keyphrases used on Google search, Google cache, and Google translate that have lead to your web server. At present this only supports Google and no other search engines. By default this panel is disabled. See --ignore-panel in your configuration file to enable it. (disabled by default)
Geo Location: Determines where an IP address is geographically located. It outputs the continent and country. It needs to be compiled with GeoLocation support
HTTP Status Codes:The values of the numeric status code to HTTP requests.
STORAGE

There are three storage options that can be used with GoAccess. Choosing one will depend on your environment and needs.

Default Hash Tables

In-memory storage provides better performance at the cost of limiting the dataset size to the amount of available physical memory. By default GoAccess uses in-memory hash tables. If your dataset can fit in memory, then this will perform fine. It has very good memory usage and pretty good performance.

Tokyo Cabinet On-Disk B+ Tree

Use this storage method for large datasets where it is not possible to fit everything in memory. The B+ tree database is slower than any of the hash databases since data has to be committed to disk. However, using an SSD greatly increases the performance. You may also use this storage method if you need data persistence to quickly load statistics at a later date.

Tokyo Cabinet In-memory Hash Database

An alternative to the default hash tables. It uses generic typing and thus it's performance in terms of memory and speed is average.

CONFIGURATION

Multiple options can be used to configure GoAccess. For a complete up-to-date list of configure options, run ./configure --help

--enable-debug
Compile with debugging symbols and turn off compiler optimizations.
--enable-utf8
Compile with wide character support. Ncursesw is required.
--enable-geoip
Compile with GeoLocation support. MaxMind's GeoIP is required.
--enable-tcb=<memhash|btree>
Compile with Tokyo Cabinet storage support. memhash will utilize Tokyo Cabinet's in-memory hash database. btree will utilize Tokyo Cabinet's on-disk B+ Tree database.
--disable-zlib
Disable zlib compression on B+ Tree database.
--disable-bzip
Disable bzip2 compression on B+ Tree database.
--with-getline
Use GNU getline() to parse full line requests instead of a fixed size buffer of 4096.
OPTIONS

The following options can be supplied via the command line or long options through the configuration file.

--time-format <timeformat>
The time-format variable followed by a space, specifies the log format time containing any combination of regular characters and special format specifiers. They all begin with a percentage (%) sign. See `man strftime`. %T or %H:%M:%S.

--date-format <dateformat>
The date-format variable followed by a space, specifies the log format date containing any combination of regular characters and special format specifiers.They all begin with a percentage (%) sign. See `man strftime`.

--log-format <logformat>
The log-format variable followed by a space or \t for tab-delimited, specifies the log format string.

Note: Generally, you need quotes around values that include white spaces, commas, pipes, quotes, and/or brackets. Inner quotes must be escaped.

-a --agent-list
Enable a list of user-agents by host. For faster parsing, do not enable this flag.

-c --config-dialog
Prompt log/date configuration window on program start.

-d --with-output-resolver
Enable IP resolver on the HTML or JSON output.

-e --exclude-ip <IP|IP-range>
Exclude an IPv4 or IPv6 from being counted. Ranges can be included as well using a dash in between the IPs (start-end).

exclude-ip 127.0.0.1
exclude-ip 192.168.0.1-192.168.0.100
exclude-ip ::1
exclude-ip 0:0:0:0:0:ffff:808:804-0:0:0:0:0:ffff:808:808
-f --log-file <logfile>
Specify the path to the input log file. If set in the config file, it will take priority over -f from the command line.

-g --std-geoip
Standard GeoIP database for less memory usage.

-h --help
The help.

-H --http-protocol
Include HTTP request protocol if found. This will create a request key containing the request protocol + the actual request.

-i --hl-header
Color highlight active panel.

--no-csv-summary
Disable summary metrics on the CSV output.

-m --with-mouse
Enable mouse support on main dashboard.

-M --http-method
Include HTTP request method if found. This will create a request key containing the request method + the actual request.

-o --output-format <json|csv>
Write output to stdout given one of the following formats: csv : Comma-separated values (CSV)json : JSON (JavaScript Object Notation)

-p --config-file <configfile>
Specify a custom configuration file to use. If set, it will take priority over the global configuration file (if any).

-q --no-query-string
Ignore request's query string. i.e., www.google.com/page.htm?query => www.google.com/page.htm

Note: Removing the query string can greatly decrease memory consumption, especially on timestamped requests.

-r --no-term-resolver
Disable IP resolver on terminal output.

-s --storage
Display current storage method. i.e., B+ Tree, Hash.

--dcf
Display the path of the default config file when -p is not used.

-V --version
Display version information and exit.

--color-scheme <1|2>
Choose among terminal color schemes. 1 for the default grey scheme. 2 for the green scheme.

--no-color
Turn off colored output. This is the default output on terminals that do not support colors.

--color=<fg:bg[attrs, PANEL>
Specify custom colors for the terminal output.

Color Syntax:

DEFINITION space/tab colorFG#:colorBG# [attributes,PANEL]
FG# = foreground color [-1...255] (-1 = default term color)
BG# = background color [-1...255] (-1 = default term color)
Optionally, it is possible to apply color attributes (multiple attributes are comma separated), such as: bold,underline,normal,reverse,blink

If desired, it is possible to apply custom colors per panel, that is, a metric in the REQUESTS panel can be of color A, while the same metric in the BROWSERS panel can be of color B.

COLOR_MTRC_HITS
COLOR_MTRC_VISITORS
COLOR_MTRC_DATA
COLOR_MTRC_BW
COLOR_MTRC_AVGTS
COLOR_MTRC_CUMTS
COLOR_MTRC_MAXTS
COLOR_MTRC_PROT
COLOR_MTRC_MTHD
COLOR_MTRC_PERC
COLOR_MTRC_PERC_MAX
COLOR_PANEL_COLS
COLOR_BARS
COLOR_ERROR
COLOR_SELECTED
COLOR_PANEL_ACTIVE
COLOR_PANEL_HEADER
COLOR_PANEL_DESC
COLOR_OVERALL_LBLS
COLOR_OVERALL_VALS
COLOR_OVERALL_PATH
COLOR_ACTIVE_LABEL
COLOR_BG
COLOR_DEFAULT
COLOR_PROGRESS
See configuration file for a sample color scheme.

--no-column-names
Don't write column names in the terminal output. By default, it displays column names for each available metric in every panel.

--html-report-title
Set HTML report page title and header.

--debug-file <debugfile>
Send all debug messages to the specified file. Needs to be configured with --enable-debug

--invalid-requests <filename>
Log invalid requests to the specified file.

--no-global-config
Do not load the global configuration file. This directory should normally be /usr/etc/, /etc/ or /usr/local/etc/, unless specified with --sysconfdir=/dir at the time of running ./configure

--real-os
Display real OS names. e.g, Windows XP, Snow Leopard.

----sort-panel=<PANEL,FIELD,ORDER>
Sort panel on initial load. Sort options are separated by comma. Options are in the form: PANEL,METRIC,ORDER
Available Metrics

BY_HITS Sort by hits
BY_VISITORS Sort by unique visitors
BY_DATA Sort by data
BY_BW Sort by bandwidth
BY_AVGTS Sort by average time served
BY_CUMTS Sort by cumulative time served
BY_MAXTS Sort by maximum time served
BY_PROT Sort by http protocol
BY_MTHD Sort by http method
Available orders
ASC
DESC
--static-file <extension>
Add static file extension. e.g.: .mp3. Extensions are case sensitive.

--all-static-files
Include static files that contain a query string.

--double-decode
Decode double-encoded values. This includes, user-agent, request, and referer.

--ignore-crawlers
Ignore crawlers.

--ignore-status=<STATUS>
Ignore parsing and displaying one or multiple status code(s). For multiple status codes, use this option multiple times.

--ignore-panel=<PANEL>
Ignore parsing/displaying the given panel. List of panels:

VISITORS
REQUESTS
REQUESTS_STATIC
NOT_FOUND
HOSTS
OS
BROWSERS
VISIT_TIMES
VIRTUAL_HOSTS
REFERRERS
REFERRING_SITES
KEYPHRASES
GEO_LOCATION
STATUS_CODES
--ignore-referer=<referer>
Ignore referers from being counted. Wildcards allowed. e.g., *.domain.com ww?.domain.*

--444-as-404
Treat non-standard status code 444 as 404.

--4xx-to-unique-count
Add 4xx client errors to the unique visitors count.

--no-progress
Disable progress metrics [total requests/requests per second] when parsing a log.

--no-tab-scroll
Disable scrolling through panels when TAB is pressed or when a panel is selected using a numeric key.

--geoip-database <geocityfile>
Specify path to GeoIP database file. i.e., GeoLiteCity.dat. File needs to be downloaded from maxmind.com. IPv4 and IPv6 files are supported as well. Note: --geoip-city-data is an alias of --geoip-database.

--keep-db-files
Persist parsed data into disk. If database files exist, files will be overwritten. This should be set to the first dataset. Setting it to false will delete all database files when exiting the program. See examples below.

Only if configured with --enable-tcb=btree

--load-from-disk
Load previously stored data from disk. If reading persisted data only, the database files need to exist. See keep-db-files and examples below. See keep-db-files and examples below.

Only if configured with --enable-tcb=btree

--db-path <dir>
Path where the on-disk database files are stored. The default value is the /tmp directory.

Only if configured with --enable-tcb=btree

--xmmap <num>
Set the size in bytes of the extra mapped memory. The default value is 0.

Only if configured with --enable-tcb=btree

--cache-lcnum <num>
Specifies the maximum number of leaf nodes to be cached. If it is not more than 0, the default value is specified. The default value is 1024. Setting a larger value will increase speed performance, however, memory consumption will increase. Lower value will decrease memory consumption.

Only if configured with --enable-tcb=btree

--cache-ncnum <num>
Specifies the maximum number of non-leaf nodes to be cached. If it is not more than 0, the default value is specified. The default value is 512.

Only if configured with --enable-tcb=btree

--tune-lmemb <num>
Specifies the number of members in each leaf page. If it is not more than 0,the default value is specified. The default value is 128.

Only if configured with --enable-tcb=btree

--tune-nmemb <num>
Specifies the number of members in each non-leaf page. If it is not more than 0, the default value is specified. The default value is 256.

Only if configured with --enable-tcb=btree

--tune-bnum <num>
Specifies the number of elements of the bucket array. If it is not more than 0,the default value is specified. The default value is 32749. Suggested size of the bucket array is about from 1 to 4 times of the number of all pages to be stored.

Only if configured with --enable-tcb=btree

--compression <zlib|bz2>
Specifies that each page is compressed with ZLIB|BZ2 encoding.

Only if configured with --enable-tcb=btree

Processing Logs Incrementally

GoAccess has the ability to process logs incrementally through the on-disk B+Tree database. It works in the following way:

A data set must be persisted first with --keep-db-files, then the same data set can be loaded with --load-from-disk.
If new data is passed (piped or through a log file), it will append it to the original data set.
To preserve the data at all times, --keep-db-files must be used.
If --load-from-disk is used without --keep-db-files, database files will be deleted upon closing the program.
Examples

// last month access log
goaccess -f access.log.1 --keep-db-files
then, load it with
// append this month access log, and preserve new data
goaccess -f access.log --load-from-disk --keep-db-files
To read persisted data only (without parsing new data)
goaccess --load-from-disk --keep-db-files
CUSTOM LOG/DATE FORMAT

GoAccess can parse virtually any web log format.

Predefined options include, Common Log Format (CLF), Combined Log Format (XLF/ELF), including virtual host, W3C format (IIS) and Amazon CloudFront (Download Distribution).

GoAccess allows any custom format string as well.

There are two ways to configure the log format. The easiest is to run GoAccess with -c to prompt a configuration window. However this won't make it permanent, for that you will need to specify the format in the configuration file.

The configuration file resides under: %sysconfdir%/goaccess.conf or ~/.goaccessrc

Note %sysconfdir% is either /etc/, /usr/etc/ or /usr/local/etc/

time-format The time-format variable followed by a space, specifies the log format date containing any combination of regular characters and special format specifiers. They all begin with a percentage (%) sign. See `man strftime`. %T or %H:%M:%S.

Note: If a timestamp is given in microseconds, %f must be used as time-format

date-format The date-format variable followed by a space, specifies the log format date containing any combination of regular characters and special format specifiers. They all begin with a percentage (%) sign. See `man strftime`.

Note: If a timestamp is given in microseconds, %f must be used as date-format

log-format The log-format variable followed by a space or \t for tab-delimited, specifies the log format string.

%x A date and time field matching the time-format and date-format variables. This is used when a timestamp is given instead of the date and time being in two separated variables.

%ttime field matching the time-format variable.

%ddate field matching the date-format variable.

%vThe canonical Server Name of the server serving the request (Virtual Host).

%hhost (the client IP address, either IPv4 or IPv6)

%rThe request line from the client. This requires specific delimiters around the request (as single quotes, double quotes, or anything else) to be parsable. If not, we have to use a combination of special format specifiers as %m %U %H.

%qThe query string.

%mThe request method.

%UThe URL path requested.

Note: If the query string is in %U, there is no need to use %q. However, if the URL path, does not include any query string, you may use %q and the query string will be appended to the request.

%HThe request protocol.

%sThe status code that the server sends back to the client.

%bThe size of the object returned to the client.

%RThe "Referer" HTTP request header.

%uThe user-agent HTTP request header.

%DThe time taken to serve the request, in microseconds.

%TThe time taken to serve the request, in seconds with milliseconds resolution.

%L The time taken to serve the request, in milliseconds as a decimal number.

Note: If multiple time served specifiers are used at the same time, the first option specified in the format string will take priority over the other specifiers.

%^Ignore this field.

%~Move forward through the log string until a non-space (!isspace) char is found.

GoAccess requires the following fields:

a valid IPv4/6 %h
a valid date %d
the request %r
INTERACTIVE KEYS

F1 or hMain help.

F5Redraw main window.

qQuit the program, current window or collapse active module

o or ENTERExpand selected module or open window

0-9 and Shift + 0Set selected module to active

jScroll down within expanded module

kScroll up within expanded module

cSet or change scheme color

^ fScroll forward one screen within active module

^ bScroll backward one screen within active module

TABIterate modules (forward)

SHIFT + TABIterate modules (backward)

sSort options for active module

/Search across all modules (regex allowed)

nFind position of the next occurrence

gMove to the first item or top of screen

Gmove to the last item or bottom of screen

EXAMPLES

Different Outputs

To output to a terminal and generate an interactive report:

# goaccess -f access.log
To generate an HTML report:

# goaccess -f access.log -a > report.html
To generate a JSON report:

# goaccess -f access.log -a -d -o json > report.json
To generate a CSV file:

# goaccess -f access.log --no-csv-summary -o csv > report.csv
The -a flag indicates that we want to process an agent-list for every host parsed.
The -d flag indicates that we want to enable the IP resolver on the HTML | JSON output.(It will take longer time to output since it has to resolve all queries.)
The -c flag will prompt the date and log format configuration window. Only when curses is initialized.
Multiple Log Files

Now if we want to add more flexibility to GoAccess, we can do a series of pipes. For instance:

If we would like to process all access.log.*.gz we can do one of the following:

# zcat -f access.log* | goaccess
# zcat access.log.*.gz | goaccess
Note: On Mac OS X, use gunzip -c instead of zcat.

Working with Dates

Another useful pipe would be filtering dates out of the web log

The following will get all HTTP requests starting on 05/Dec/2010 until the end of the file.

# sed -n '/05\/Dec\/2010/,$ p' access.log | goaccess -a
or using relative dates such as yesterdays or tomorrows day:

# sed -n '/'$(date '+%d\/%b\/%Y' -d '1 week ago')'/,$ p' access.log | goaccess -a
If we want to parse only a certain time-frame from DATE a to DATE b, we can do:

# sed -n '/5\/Nov\/2010/,/5\/Dec\/2010/ p' access.log | goaccess -a
Virtual Hosts

Assuming your log contains the virtual host field. For instance:

vhost.com:80 10.131.40.139 - - [02/Mar/2016:08:14:04 -0600] "GET /shop/bag-p-20 HTTP/1.1" 200 6715 "-" "Apache (internal dummy connection)"
And you would like to append the virtual host to the request in order to see which virtual host the top urls belong to

awk '$8=$1$8' access.log | goaccess -a
To exclude a list of virtual hosts you can do the following:

# grep -v "`cat exclude_vhost_list_file`" vhost_access.log | goaccess
Files & Status Codes

To parse specific pages, e.g., page views, html, htm, php, etc. within a request:

# awk '$7~/\.html|\.htm|\.php/' access.log | goaccess
Note, $7 is the request field for the common and combined log format, (without Virtual Host), if your log includes Virtual Host, then you probably want to use $8 instead. It's best to check which field you are shooting for, e.g.:

# tail -10 access.log | awk '{print $8}'
Or to parse a specific status code, e.g., 500 (Internal Server Error):

# awk '$9~/500/' access.log | goaccess
Server

Also, it is worth pointing out that if we want to run GoAccess at lower priority, we can run it as:

# nice -n 19 goaccess -f access.log -a
and if you don't want to install it on your server, you can still run it from your local machine:

# ssh root@server 'cat /var/log/apache2/access.log' | goaccess -a
NOTES

For now, each active window has a total of 366 items. Eventually this will be customizable. These 366 items are all available by default in the CSV and JSON exports, and as an expandable panel in the HTML report (upper-right corner).

Piping a log to GoAccess will disable the real-time functionality. This is due to the portability issue on determining the actual size of STDIN. However, a future release *might* include this feature.

A hit is a request (line in the access log), e.g., 10 requests = 10 hits. HTTP requests with the same IP, date, and user agent are considered a unique visit.

BUGS

If you think you have found a bug, please send me an email to  GoAccess' email

AUTHOR

Gerardo Orellana. For more details about it, or new releases, please visit http://goaccess.io

-------------------------------------------------------------------------------------------------
需要注意这里的日志格式，每个nginx日志格式配置可能不同，goaccess指定的日志格式也不一定一样，需要对照下面的参数和nginx日志格式来指定命令中日志的格式。否则日志
分析的时候会报错。需要对nginx的日志格式有一定了解。
goaccess时间和日志格式支持的参数：
date_format
The date_format variable followed by a space, specifies the log format date containing any combination of regular characters and special format specifiers. They all
begin with a percentage (%) sign. See http://linux.die.net/man/3/strftime
Note that there is no need to use time specifiers since they are not used by GoAccess. It’s recommended to use only date specifiers, i.e., %Y-%m-%d.
log_format
The log_format variable followed by a space or \t , specifies the log format string.
%d date field matching the date_format variable.
%h host (the client IP address, either IPv4 or IPv6)
%r The request line from the client. This requires specific delimiters around the request (as single quotes, double quotes, or anything else) to be parsable. If not, we
have to use a combination of special format specifiers as %m %U %H.
%m The request method.
%U The URL path requested (including any query string).
%H The request protocol.
%s The status code that the server sends back to the client.
%b The size of the object returned to the client.
%R The “Referrer” HTTP request header.
%u The user-agent HTTP request header.
%D The time taken to serve the request, in microseconds.
%T The time taken to serve the request, in seconds or milliseconds. Note: %D will take priority over %T if both are used.
%^ Ignore this field.
PS:
之前配置文件错误，分析nginx日志报错，经过求助软件作者解决，并对goaccess有更深入的了解。赞一下软件作者。
[root@Rootop ~]# goaccess -d -f /home/wwwlogs/www.rootop.org.log -a -p ~/.goaccesssrc > test.html
Parsing… [373,734] [373,734/s]
GoAccess – version 0.8.5 – Nov 20 2014 16:48:39
Fatal error has occurred
Error occured at: goaccess.c – main – 832
Nothing valid to process.
~/.goaccesssrc文件内容：
date_format %d/%b/%Y
log_format %^:%^ %h %^[%d:%^] “%r” %s %b
nginx日志:
58.251.136.61 – - [20/Nov/2014:17:29:21 +0800] “GET /wp-content/themes/g-white/js/all.js HTTP/1.1″200 1292 “http://www.rootop.org/pages/890.html”"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36″ -
```