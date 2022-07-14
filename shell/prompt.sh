# -----------------------------------------------------------------------------

# prompt.sh

# _bash_simple_prompt
#       _format_info
# _zsh_simple_prompt
#       _format_info
# _bash_git_prompt
#       _bash_simple_prompt
#       _format_info
# _zsh_git_prompt
#       _zsh_simple_prompt
#       _format_info
# _zsh_vcs_prompt
#       _zsh_simple_prompt
#       _format_info

# -----------------------------------------------------------------------------

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# -----------------------------------------------------------------------------

# Format info                   remove it in prompt if no need
_format_info (){
    # "| Time 2000-01-01/01:01:00 "
    echo -e "| Time $(date +%Y-%m-%d/%H:%M:%S) \c"
    # "| Up 10:00 | Users 1 | Load 0.01,0.01,0.01"
    # some error if up days
    echo -e "$(uptime | awk '{print "| Up " $3 " | Users " $4 " | Load " $8$9$10}' | sed 's/,//') "
}
# $(_format_info "%s")
#_format_info

# -----------------------------------------------------------------------------

# Bahs simple-prompt
_bash_simple_prompt (){
    # Set a simple PS1
    PS1='\[\e[07;40;37m\][\h \u \w]\[\e[00m\]\n[\$]: '

    # Or use git-prompt
}
#_bash_simple_prompt

# -----------------------------------------------------------------------------

# Zsh simple-prompt
_zsh_simple_prompt (){
    # prompt
    autoload -Uz promptinit
    promptinit
    # colors
    autoload -Uz colors && colors

    # Use builtin prompt
    #prompt clint

    # Or set a simple prompt
    prompt restore
    setopt prompt_subst
    PROMPT="%K{white}%{$fg[black]%}[%m %n %~]%{$reset_color%}%k"$'\n'
    PROMPT+="[%#]: "
    RPROMPT="[%? %L]"

    # Or use git-prompt or vcs-prompt
}
#_zsh_simple_prompt

# -----------------------------------------------------------------------------

# Bash git-prompt
# !!!git-prompt will slow down prompt!!!
_bash_git_prompt (){
    # simple-prompt to fallback
    _bash_simple_prompt

    # use git-prompt if have git-sh-prompt                 $(__git_ps1 " (%s)")
    # /usr/lib/git-core/git-sh-prompt
    # /etc/bash_completion.d/git-prompt
    if [ -r "/usr/lib/git-core/git-sh-prompt" ]; then
        . '/usr/lib/git-core/git-sh-prompt'
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
    fi
}
# !!!git-prompt will slow down prompt!!!
#_bash_git_prompt

# -----------------------------------------------------------------------------

# Zsh git-prompt
# !!!git-prompt will slow down prompt!!!
_zsh_git_prompt (){
    # simple-prompt for fallback
    _zsh_simple_prompt

    # use git-prompt if have git-sh-prompt                 $(__git_ps1 " (%s)")
    # /usr/lib/git-core/git-sh-prompt
    if [ -r "/usr/lib/git-core/git-sh-prompt" ]; then
        . '/usr/lib/git-core/git-sh-prompt'
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
    fi
}
# !!!git-prompt will slow down prompt!!!
#_zsh_git_prompt

# -----------------------------------------------------------------------------

# Zsh vcs-prompt        no auto color
# !!!vcs-prompt will slow down prompt!!!
_zsh_vcs_prompt (){
    # simple-prompt for fallback
    _zsh_simple_prompt

    # version control system info
    autoload -Uz vcs_info
    zstyle ':vcs_info:*' enable git svn
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' unstagedstr ' *'
    zstyle ':vcs_info:*' stagedstr ' +'
    # %s    the vcs in use
    # %r    the repo name
    # %S    a subdir within a repo
    # %b    info about the current branch
    # %a    an identifier that describes the action(only in actionformats)
    # %m    misc
    # %u    the string from the unstagedstr
    # %c    the string from the stagedstr
    zstyle ':vcs_info:git*' formats "%s %r/%S %b%a %m%u%c"
    zstyle ':vcs_info:git*' actionformats "%s  %r/%S %b|%a %m%u%c"
    # %b    the branch name
    # %r    the current revision number
    zstyle ':vcs_info:git*' branchformats "%b%r"
    # precmd
    precmd (){
        vcs_info
        if [[ -z ${vcs_info_msg_0_} ]]; then
            #PS1="%5~%# "
            PROMPT="%K{white}%{$fg[black]%}[%m %n %~]%{$reset_color%}%k"$'\n'
            PROMPT+="[%#]: "
            RPROMPT="[%? %L]"
        else
            #PS1="%3~${vcs_info_msg_0_}%# "
            PROMPT="%K{white}%{$fg[black]%}[%m %n %1~]%{$reset_color%}%k${vcs_info_msg_0_}"$'\n'
            PROMPT+="[%#]: "
            RPROMPT="[%? %L]"
        fi
    }
}
# !!!vcs-prompt will slow down prompt!!!
#_zsh_vcs_prompt

# -----------------------------------------------------------------------------


# End.

