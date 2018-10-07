##! @TODO : terminal output with color
##! @VERSION : 1.0.0
##! @FILE   : printLib.sh
##! @AUTHOR : SunnyChan
##! @Date : 2015/11/10

##! terminal output with color
function printLibEcho(){
    echo -e "$@"
}
function redPrint(){
    local content="\033[31m$@\033[0m"
    printLibEcho "$content"
}
function greenPrint(){
    local content="\033[32m$@\033[0m"
    printLibEcho "$content"
}
function yellowPrint(){
    local content="\033[33m$@\033[0m"
    printLibEcho "$content"
}
function bluePrint(){
    local content="\033[34m$@\033[0m"
    printLibEcho "$content"
}
function purplePrint(){
    local content="\033[35m$@\033[0m"
    printLibEcho "$content"
}
function skybluePrint(){
    local content="\033[36m$@\033[0m"
    printLibEcho "$content"
}
function whitePrint(){
    local content="\033[37m$@\033[0m"
    printLibEcho "$content"
}
function whiteBlackPrint(){
    local content="\033[40;37m$@\033[0m"
    printLibEcho "$content"
}
function whiteRedPrint(){
    local content="\033[41;37m$@\033[0m"
    printLibEcho "$content"
}
function whiteGreenPrint(){
    local content="\033[42;37m$@\033[0m"
    printLibEcho "$content"
}
function whiteYellowPrint(){
    local content="\033[43;37m$@\033[0m"
    printLibEcho "$content"
}
function whiteBluePrint(){
    local content="\033[44;37m$@\033[0m"
    printLibEcho "$content"
}
function whitePurplePrint(){
    local content="\033[45;37m$@\033[0m"
    printLibEcho "$content"
}
function whiteSkybluePrint(){
    local content="\033[46;37m$@\033[0m"
    printLibEcho "$content"
}
function blackWhitePrint(){
    local content="\033[47;30m$@\033[0m"
    printLibEcho "$content"
}

##! terminal output 
