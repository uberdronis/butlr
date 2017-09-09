# ---------------------------------------------
# Creator: Pedro Ferraz
# Created: 08/20/2011
# Updated: 09/08/2017
#
# Description: Bash Customizations
#
# Requires: .bash_profile
#
# Helpful resources:
# 1. https://natelandau.com/my-mac-osx-bash_profile/
# 2. https://natelandau.com/bash-scripting-utilities/
#
# Sections:
# 1. Environment Config
# 2. Performance monitor
# 3. Network Commands/Functions
# 4. Development Commands/Functions
# X. Notes and Executions
# ---------------------------------------------

# Section 1. Environment Config
  # fun commands
  alias cheers="echo $'\360\237\215\272'"   # beer mug
  alias cheers2="echo $'\360\237\215\273'"  # double beer mug
  alias cheers3="echo $'\360\237\215\271'"  # mai-tai
  alias cheers4="echo $'\360\237\215\270'"  # martini
  alias cheers5="echo $'\360\237\215\274'"  # baby bottle

  # terminal shortcuts
  alias ~='cd ~'                # go home
  alias c='clear'               # clear the screen
  alias f='open -a Finder ./'   # open Finder in this folder

  # terminal command enhancements and custom aliases
  alias cp='cp -iv'                         # confirm overwrites and verbose
  alias dt='tee ~/Desktop/terminalout.txt'  # pushes all output to a file on the Desktop
  alias ducks='du -cksh *'                  # directory information
  alias la='ls -Gahxo'                      # comprehensive listing
  alias less='less -FSRXc'                  # preferred less implementation
  alias ll='ls -FGlAhp'                     # preferred ls implementation
  alias mkdir='mkdir -pv'                   # recursive directory and verbose
  alias mv='mv -iv'                         # confirm overwrites and verbose
  alias path='echo -e ${PATH//:/\\n}'       # prints the full system path var
  alias show_options='shopt'                # show bash options for the current session

  # fully recursive .DS_Store cleanup
  alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

  # terminal custom functions
  mkd () { mkdir -p "$1" && cd "$1"; }                    # creates a folder and enters it
  grepc () { command grep -irc "$1" . | grep -v ':0' ; }  # grep counter
  grepr () { command grep -ir --color=always "$1" . ; }   # grep recursively
  trash () { command mv "$@" ~/.Trash ; }                 # moves file/folder to trash
  zipf () { zip -r "$1".zip "$1" ; }                      # zip folder/file
  makefile() { mkfile "$1"m ./"$1"_makefile.dat ; }       # make file of custom size (empty content)

  # application aliases
  alias jsc='/System/Library/Frameworks/JavaScriptCore.framework/Versions/Current/Resources/jsc'

  # extract files with a single command
  extract () {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
             esac
         else
             echo "'$1' is not a valid file"
         fi
    }

# Section 2. Performance monitor
  # custom aliases
  alias cpuhogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'         # cpu hog - PS
  alias memhogstop='top -l 1 -o rsize | head -20'                           # mem hog - TOP
  alias memhogsps='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'  # mem hog - PS
  alias top4ever='top -l 9999999 -s 10 -o cpu'                              # continuous list (refresh every 10s)- TOP
  alias ttop="top -R -F -s 10 -o rsize"                                     # best top command - minimize resource usage

  # custom functions
  my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }  # processes owned by current user

# Section 3. Network Commands/Functions
  # custom aliases
  alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
  alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
  alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
  alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
  alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
  alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections

  # get all local and remote ips
  myips() {
    localips="$(ifconfig | grep 'inet ' | cut -d ' ' -f 2 | tr '\n' ' ')"
    localips=${localips/"127.0.0.1 "/""}
    localips=${localips/" "/" / "}

    remoteip="$(curl -s http://pedronis.pythonanywhere.com/ip/me)"

    echo -e "${RED}Local IP(s):${GREEN} $localips"
    echo -e "${RED}Remote IP  :${GREEN} $remoteip"
  }

  # eject all volumes (except internal ones)
  eject_all() {
      # grab list of volumes (regex finds the volume name, cat splits them with a $ end of line)
      vols="$(df -lH | grep -o '\/Volumes\/[a-zA-Z0-9_. ]*' | tr '\n' '|')"

      # temporarily change delimiter for loop.
      OLDIFS=$IFS;
      IFS="|";

      for vol in $vols ; do
        echo -e "${RED}ejecting: $vol${GREEN}"
        hdiutil detach -force "$vol"
      done

      # restore delimiter
      IFS=$OLDIFS;
  }

# Section 4. Development Commands/Functions
  # Android Home Settings 
  export ANDROID_HOME=~/Library/Android/sdk
  PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/26.0.1:$PATH
  export PATH

  # Python3 path - used for aws_cli
  export PATH=~/Library/Python/3.6/bin:$PATH

  # mariaDB server commands
  mariadb() {
    case $1 in
      start|stop|status)  mysql.server $1 ;;
      *)                  echo "'$1' is not a valid parameter (start|stop|status)." ;;
    esac
  }

  # mongodb server commands
  mongodb() {
    case $1 in
      start)    mongod --config ~/transient/config/mongod.conf ;;
      *)        echo "'$1' is not a valid parameter (start)." ;;
    esac
  }

  # postgresql server commands
  pgsql() {
    case $1 in
      start)    pg_ctl -D ~/transient/data/pgsql -w -o '--config-file=/Users/pedro/transient/config/postgresql.conf' start ;;
      stop)     pg_ctl -D ~/transient/data/pgsql stop -s -m fast ;;
      status)   pg_ctl -D ~/transient/data/pgsql status ;;
      *)        echo "'$1' is not a valid parameter (start|stop|status)." ;;
    esac
  }

  # dev tools versions
  devtools() {
    echo -e "${RED}Dev Tools  :${GREEN}"
    echo -e "  $(python --version 2>&1) (system)"
    echo -e "  $(python2 --version 2>&1) / $(pip2 --version | cut -d 'f' -f 1)"
    echo -e "  $(python3 --version) / $(pip3 --version | cut -d 'f' -f 1)"
    echo -e "  node $(node --version) / npm $(npm --version)"
    echo -e "  mongo$(mongod --version | grep 'db version')"
    echo -e "  $(mysql --version | cut -d ',' -f 1)"
    echo -e "  $(pg_ctl --version)"
    echo -e "  $(docker --version)"
    echo -e "  $(aws --version)"
  }

# Section X. Notes and Executions
  bash_refresh() {
    source ~/.bash_profile
  }
  bash_help() {
    aliases="$(alias | cut -d ' ' -f 2 | cut -d '=' -f 1 | tr '\n' ' ')"
    functions="$(typeset -F | grep -v 'declare -f shell_session' | cut -d ' ' -f 3 | tr '\n' ' ')"

    echo -e "${RED}Functions  :${GREEN} $functions"
    echo -e "${RED}Aliases    :${GREEN} $aliases"
  }
  ii() {
    echo -e "${RED}date   :${GREEN} $(date '+%Y/%m/%d (%A) %H:%M:%S (%Z %z)')"
    echo -e "${RED}uptime :${GREEN} $(uptime)"
    echo -e "${RED}user   :${GREEN} $(whoami)"
    echo -e "${RED}host   :${GREEN} $(hostname)"
    echo -e "${RED}info   :${GREEN} $(uname -a)"
    echo -e "${RED}logins :${GREEN}" ; w -h
  }

  # run commands
  ii
  myips
  bash_help
  devtools
  brew doctor
  cheers
  echo
