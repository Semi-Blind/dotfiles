# -----------------------------------------------------------------------------

# ZSh .zshrc

# -----------------------------------------------------------------------------

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# -----------------------------------------------------------------------------

SHELL_LOAD=0
if [ $SHELL_LOAD -eq 1 ]; then
    uname -a
    uptime
    echo "zsh $ZSH_VERSION"
    echo "SHELL LOAD:"
fi

# -----------------------------------------------------------------------------

# prompt
autoload -Uz promptinit
promptinit
# colors
autoload -Uz colors && colors
#prompt clint

# use git-prompt if have git-sh-prompt                 $(__git_ps1 " (%s)")
# /usr/lib/git-core/git-sh-prompt
GIT_SH_PROMPT="/usr/lib/git-core/git-sh-prompt"
if [ -r $GIT_SH_PROMPT ] && [ 1 ]; then
    . $GIT_SH_PROMPT
    if [ $SHELL_LOAD -eq 1 ]; then
        echo " $GIT_SH_PROMPT"
    fi
    # git-prompt
    # unstaged (*) staged (+)
    GIT_PS1_SHOWDIRTYSTATE=1
    # stashed ($)
    GIT_PS1_SHOWSTASHSTATE=1
    # untracked files (%)
    GIT_PS1_SHOWUNTRACKEDFILES=1
    # differ between HEAD and upstream
    # you are behind (<)
    # you are ahead (>)
    # you have diverged (<>)
    # no difference (=)
    GIT_PS1_SHOWUPSTREAM="auto"
    # more info
    GIT_PS1_DESCRIBE_STYLE=default
    # color  available only by PROMPT_COMMAND in bash
    GIT_PS1_SHOWCOLORHINTS=1
    # hide if ignored by git
    GIT_PS1_HIDE_IF_PWD_IGNORED=1
    prompt restore
    precmd (){
        PROMPT="%K{white}%{$fg[black]%}[%m %n %~]%{$reset_color%}%k$(__git_ps1 " (%s)")"$'\n'
        PROMPT+="[%#]: "
        RPROMPT="[%? %L]"
    }
else
    # Or set a simple prompt
    prompt restore
    setopt prompt_subst
    PROMPT="%K{white}%{$fg[black]%}[%m %n %~]%{$reset_color%}%k"$'\n'
    PROMPT+="[%#]: "
    RPROMPT="[%? %L]"
fi

# -----------------------------------------------------------------------------

# Key mode

# Turn off CTRL+S suspend session
stty -ixon
# Emacs/Readline keymode
bindkey -e

# Vi keymode ********************************************************
#bindkey -v
#KEYTIMEOUT=1
#zmodload zsh/complist
#bindkey -M menuselect 'h' vi-backward-char
#bindkey -M menuselect 'k' vi-up-line-or-history
#bindkey -M menuselect 'l' vi-backward-char
#bindkey -M menuselect 'j' vi-down-line-or-history
#autoload -Uz surround
#zle -N delete-surround surround
#zle -N add-surround surround
#zle -N change-surround surround
#bindkey -M vicmd cs change-surround
#bindkey -M vicmd ds delete-surround
#bindkey -M vicmd ys add-surround
#bindkey -M vicmd S  add-surround
# *******************************************************************

# -----------------------------------------------------------------------------

# history
setopt histignorealldups sharehistory
# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
# search history
[[ -n "${key[Up]}"      ]] && bindkey "${key[Up]}"      history-search-backward
[[ -n "${key[Down]}"    ]] && bindkey "${key[Down]}"    history-search-forward

# -----------------------------------------------------------------------------

# completion
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

# comlete aliases
setopt completealiases
# auto load $PATH
zstyle ':completion:*' rehash true

# -----------------------------------------------------------------------------

# Recommand packages
# zsh-autosuggestions zsh-syntax-highlighting
# autojump command-not-found git

# -----------------------------------------------------------------------------

# Load dotfiles scripts
_load_dotfiles_scripts (){
    local dotfiles_scripts=(variables.sh aliases.sh functions.sh)
    local dotfiles_shell_path="/dotfiles/shell/"
    for dotscript in "${dotfiles_scripts[@]}"
    do
        script2load="$dotfiles_shell_path$dotscript"
        [ -r "$script2load" ] && . "$script2load"
        if [ $SHELL_LOAD -eq 1 ]; then
            echo " $script2load"
        fi
    done
}
_load_dotfiles_scripts
#declare -F | grep _load
#unset -f _load_dotfiles_scripts

# -----------------------------------------------------------------------------

# Load shell scripts
_load_shell_scripts (){
    # some example from /etc/zsh/newuser*       nolonger needed
    local newuser='/etc/zsh/newuser.zshrc.recommended'
    # zsh-autosuggestions
    local zshautosug='/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh'
    # zsh-syntax-highlighting
    local zshsyntax='/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
    # autojump
    local autojump='/usr/share/autojump/autojump.sh'
    # command-not-found     only zsh need source
    local commandnot='/etc/zsh_command_not_found'
    # gitprompt             $(__git_ps1 " (%s)")
    local gitprompt='/usr/lib/git-core/git-sh-prompt'
    # scripts to load
    local scripts2load=("$zshautosug" "$zshsyntax") # "$autojump" "$commandnot" "$gitprompt"
    # Load scripts
    for script2load in "${scripts2load[@]}"
    do
        [ -r "$script2load" ] && . "$script2load"
        if [ $SHELL_LOAD -eq 1 ]; then
            echo " $script2load"
        fi
    done
}
_load_shell_scripts
#declare -F | grep _load
#unset -f _load_shell_scripts

# -----------------------------------------------------------------------------

# End.

