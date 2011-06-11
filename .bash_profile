#!/bin/bash
#export DYLD_FALLBACK_LIBRARY_PATH="${HOME}/wine/wine-1.2/lib:/usr/X11/lib:/usr/lib"
export PATH=/opt/local/bin:/opt/local/sbin:/Users/auxten/scripts/:$PATH
export MANPATH=/opt/local/man:$MANPATH
export TERM=xterm-color
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export CVSROOT=:pserver:wangpengcheng01@newcvs.baidu.com:/data/cvsroot
export CVS_RSH=ssh
export EDITOR=vi

ulimit -c unlimited
ulimit -n 10240
ulimit -s 10240

alias gocode="echo '**************Now Coding***************' && cd /Users/auxten/Documents/Codes"
alias cd..="cd .."
alias ll="ls -l"
alias la="ls -a"
alias lt="ls -ltr"
alias qsh="ssh -p 1998 "
alias ntst="lsof -ni -P"
# /etc/bash/bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

# Change the window title of X terminals 
case ${TERM} in 
    xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
        ;; 
    screen)
        PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
        ;;
esac

use_color=false

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
    && type -P dircolors >/dev/null \
    && match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
    # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
    if type -P dircolors >/dev/null ; then
        if [[ -f ~/.dir_colors ]] ; then
            eval $(dircolors -b ~/.dir_colors)
        elif [[ -f /etc/DIR_COLORS ]] ; then
            eval $(dircolors -b /etc/DIR_COLORS)
        fi
    fi

    if [[ ${EUID} == 0 ]] ; then
        PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
    else
        PS1='\[\033[01;33m\]Mac.\[\033[01;34m\]\[\033[01;32m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
	#PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
    fi

    alias ls='ls -G'
    alias grep='grep --colour=auto'
else
    if [[ ${EUID} == 0 ]] ; then
        # show root@ when we don't have colors
        PS1='\u@\h \W \$ '
    else
        PS1='\u@\h \w \$ '
    fi
fi

# Try to keep environment pollution down, EPA loves us.
unset use_color safe_term match_lhs

