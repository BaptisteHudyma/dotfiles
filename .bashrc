#
# ~/.bashrc
#

# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
if type -P dircolors >/dev/null ; then
	if [[ -f ~/.dir_colors ]] ; then
		eval $(dircolors -b ~/.dir_colors)
	elif [[ -f /etc/DIR_COLORS ]] ; then
		eval $(dircolors -b /etc/DIR_COLORS)
	fi
fi

#colors
alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'

alias cp="cp -i"                          # confirm before overwriting something
alias torrent="transmission-cli"
alias rm="rm -I"			#confirm before removing more than three files or recursiv
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less
alias ll='ls -lAh'
alias runaswine="$HOME/.script_bash/runaswine"
alias pacman="sudo pacman --color=auto"
alias maj="sudo pacman -Syu"		  # app maj
alias op="sudo chmod a+rw"	  # open access to a port (arduino)
alias leekwars="python $HOME/Documents/code/python/LWAPI/leekwars_api.py"
alias messenger="caprine"


alias mbed_compile="$HOME/.script_bash/mbed_compile.sh"
alias qtcreator="/opt/Qt/Tools/QtCreator/bin/qtcreator"

alias fritzing="$HOME/Fritzing/Fritzing"
alias backup="sudo timeshift --create --snapshot-device"
alias pclear="paccache -rk1"

#[[ $- != *i* ]] && return

#BOOST lib
export BOOST=/usr/include/boost
export BOOST_ROOT=/usr/include/boost
export BOOST_LIBRARY_DIRS="/usr/lib64/cmake/Boost-1.72.0"
export BOOST_INCLUDEDIR=$BOOST_ROOT
export LD_LIBRARY_PATH=/usr/lib:$LD_LIBRARY_PATH

#Python
export PYTHONPATH=/usr/local/bin/python
export PYTHON_INCLUDE_DIRS=/usr/include/python3.8

#Init pyenv
export PATH="/home/baptou/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

#RDKit
export RDBASE=$HOME/.RDKit/RDKit_2020_09_1
export LD_LIBRARY_PATH=$RDBASE/lib:$LD_LIBRARY_PATH
export PYTHONPATH=$RDBASE:$PYTHONPATH



man() {
    env \
    LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;31m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[01;31m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[01;32m' \
    man "$@"
}

table_flip () {
	if [[  $? == 0 ]]; then
        echo ""
    else
		echo "(╯°□°)╯︵ ┻━┻ 
 "
	fi
}

#GIT functions
get_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
parse_git_branch() {
    git rev-parse --git-dir &> /dev/null
    git_status="$(git status 2> /dev/null)"
    branch_pattern="^# Sur la branche ([^${IFS}]*)"
    remote_pattern="# Votre branche est (.*) '"
    diverge_pattern="# Votre branche et (.*) ont divergé"

    if [[ ! ${git_status}} =~ "la copie de travail est propre" ]]; then
        state="${YELLOW}⚡"
    fi
    # add an else if or two here if you want to get more specific
    if [[ ${git_status} =~ ${remote_pattern} ]]; then
        if [[ ${BASH_REMATCH[1]} == "en avance sur" ]]; then
            remote="${YELLOW}↑"
        else
            remote="${YELLOW}↓"
        fi
    fi
    if [[ ${git_status} =~ ${diverge_pattern} ]]; then
        remote="${YELLOW}↕"
    fi
    if [[ ${git_status} =~ ${branch_pattern} ]]; then
        branch=${BASH_REMATCH[1]}
        echo " (${branch})${remote}${state}"
    fi
}
git_dirty_flag() {
    git status 2> /dev/null | grep -c : | awk '{if ($1 > 0) print "⚡"}'
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion


RED="\[\033[0;31m\]" GREEN="\[\033[1;32m\]" CYAN="\[\033[0;36m\]" BLUE="\[\033[0;34m\]" LIGHT_RED="\[\033[1;31m\]" LIGHT_GREEN="\[\033[1;32m\]" WHITE="\[\033[1;37m\]" LIGHT_GRAY="\[\033[0;37m\]" PURPLE="\[\033[32m\]" LIGHT_ORANGE="\[\033[33m\]" YELLOW="\[\033[1;33m\]"
RESET="\[$(tput sgr0)\]"

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		#PROMPT_COMMAND='echo -ne "\033]0${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		#PROMPT_COMMAND='echo -ne "\033_${PWD/#$HOME/\~}\033\\"'
		;;
esac

#root
if [[ ${EUID} == 0 ]] ; then
	PS1='$(table_flip)'"${RED}[\h${CYAN} \W${LIGHT_RED}\$${RESET} "
else    #user
    PS1='$(table_flip)'"${GREEN}[\u \W]${LIGHT_ORANGE}"'$(get_git_branch)$(parse_git_branch)'"${YELLOW}"'$(git_dirty_flag)'"${RESET} "
fi

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

fortune



