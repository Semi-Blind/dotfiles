# -----------------------------------------------------------------------------

# Bash .bashrc

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
    echo "bash $BASH_VERSION"
    echo "SHELL LOAD:"
fi

# -----------------------------------------------------------------------------

# PS1
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

    # color  available only by PROMPT_COMMAND in bash
    PROMPT_COMMAND='__git_ps1 '
    # string before git info
    PROMPT_COMMAND+='"\[\e[07;40;37m\][\h \u \w]\[\e[00m\]" '
    # string after git info
    PROMPT_COMMAND+='"\n[\$]: " '
    # git info
    PROMPT_COMMAND+='" (%s)"'
else
    # Set a simple PS1
    PS1='\[\e[07;40;37m\][\h \u \w]\[\e[00m\]\n[\$]: '
fi

# -----------------------------------------------------------------------------

# Emacs/Readline keymode
set -o emacs
#set -o vi

# -----------------------------------------------------------------------------

# History
# !!            expand to the last command
# !n            expand the command with history number 'n'
# !-n           expand to 'n' last command
# CTRL+R        search
# CTRL+S        search back (conflict with suspend the terminal session)
# CTRL+Q        unsuspend the session
# Turn off CTRL+S suspend session
stty -ixon
# UP DOWN arrow search in history
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
# ignoreboth=ignorespace, ignoredups
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# -----------------------------------------------------------------------------

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# autocd
shopt -s autocd

# -----------------------------------------------------------------------------

# some examples from bashrc.bfox

# Don't make useless coredump files.  If you want a coredump,
# say "ulimit -c unlimited" and then cause a segmentation fault.
ulimit -c 0

# Set auto_resume if you want to resume on "emacs", as well as on
# "%emacs".
auto_resume=exact

# Set notify if you want to be asynchronously notified about background
# job completion.
set -o notify

# Make it so that failed `exec' commands don't flush this shell.
shopt -s execfail

# -----------------------------------------------------------------------------

# Recommand packages
# bash-doc bash-builtins bash-completion
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
    # some example from /etc/skel/.bashrc   no longer needed
    local newuser='/etc/skel/.bashrc'
    # bash-completion
    local bashcompletion='/usr/share/bash-completion/bash_completion'
    # autojump
    local autojump='/usr/share/autojump/autojump.sh'
    # command-not-found     only zsh need source
    local commandnot='/etc/bash_command_not_found'
    # scripts to load
    local scripts2load=("$bashcompletion") # "$autojump"
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

