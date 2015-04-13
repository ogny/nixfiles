# Set up the prompt
#autoload -Uz promptinit
#promptinit
#prompt off
#PS1=' %~ 
#%# '
bindkey -v

setopt correctall
setopt autocd
setopt hist_ignore_all_dups
setopt hist_ignore_space
#Kaynak: http://wiki.gentoo.org/wiki/Zsh/HOWTO
setopt dotglob
setopt histignorealldups sharehistory
# append to the history file, don't overwrite it
setopt histappend
# isaretini comment olarak yorumlasin.
set -k

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:task:*' verbose yes
zstyle ':completion:*:*:task:*:descriptions' format '%U%B%d%b%u' 
zstyle ':completion:*:*:task:*' group-name ''

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# # See bash(1) for more options
HISTCONTROL=ignoreboth

# set a fancy prompt (non-color, unless we know we "want" color)
#case "$TERM" in
#    xterm-color) color_prompt=yes;;
#esac


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.zsh/zsh_aliases ]; then
    . ~/.zsh/zsh_aliases
fi

# load exports
if [ -f ~/.zsh/zsh_exports ]; then
  source ~/.zsh/zsh_exports
fi

#zargan
zl(){
        z $@ | head -10
}
zz(){
        z $@ | more
}
#man() {
#        env \
#        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
#                LESS_TERMCAP_md=$(printf "\e[1;31m") \
#                LESS_TERMCAP_me=$(printf "\e[0m") \
#                LESS_TERMCAP_se=$(printf "\e[0m") \
#                LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
#                LESS_TERMCAP_ue=$(printf "\e[0m") \
#                LESS_TERMCAP_us=$(printf "\e[1;32m") \
#                        man "$@"
#}

uncomment() {
sed -e 's/#.*//' -e 's/[ ^I]*$//' -e '/^$/ d' $1
}
lm () {
find $1 -maxdepth 1 -type f -printf '%f\n'
}
#source $HOME/bin/sshag.sh >/dev/null 2>&1
eval "$(fasd --init auto)"
eval `dircolors ~/Git_Repolari/diger/dircolors-solarized/dircolors.256dark`
alias x='ssh-agent startx'
#fpath=($HOME/.zsh/completion $fpath) 
compdef _task t='task'

# Initialize colors.
autoload -U colors
colors
 
# Allow for functions in the prompt.
setopt PROMPT_SUBST
 
# Autoload zsh functions.
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)
 
# Enable auto-execution of functions.
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions
 
# Append git functions needed for prompt.
preexec_functions+='preexec_update_git_vars'
precmd_functions+='precmd_update_git_vars'
chpwd_functions+='chpwd_update_git_vars'
 
# Set the prompt.
PROMPT=$'%{${fg[cyan]}%}%B%~%b$(prompt_git_info)
%#%{${fg[default]}%} '

vman() {
  vim -c "SuperMan $*"

  if [ "$?" != "0" ]; then
    echo "No manual entry for $*"
  fi
}

compdef vman="man"

eval "$(chef shell-init zsh)"

# pip zsh completion start
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] ) )
}
compctl -K _pip_completion pip
# pip zsh completion end

#source /usr/local/bin/virtualenvwrapper.sh
#source ~/Git_Repolari/diger/sshag/sshag.sh; sshag &>/dev/null
source ~/Git_Repolari/diger/sshag/sshag.sh >/dev/null 2>&1
#source ~/Git_Repolari/diger/sshag/sshag.sh 
