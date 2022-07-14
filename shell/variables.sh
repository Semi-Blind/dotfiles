# Shell variables.sh

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# umask as default -rw-r--r--
umask 0022

# PATH (/etc/profile)
if [ "$(id -u)" -eq 0 ]; then
  PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
else
  PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
fi
export PATH
# PATH (~/.profile)
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# editors
EDITOR="vim"
VISUAL="vim"

# Color
# real color depend on your terminal and theme
TERM=xterm-256color

# for doom emacs
#export DOOMGITCONFIG=~/.gitconfig
#PATH+=:~/.emacs.d/bin

# locale !!!this is only for shell script!!!
# `LANG` default locale
# will be used for all `LC_*` variables that are not explicitly set
# `C.UTF-8` for Computer bytes, not humans
LANG='C.UTF-8'
# `LANGUAGE` fallback locales
# work if `LC_ALL` and `LANG` are not set to 'C.UTF-8'
LANGUAGE='C.UTF-8'
# `LC_ALL=C` overrides all `LC_*` !!!dont use for system locale!!!
LC_ALL='C.UTF-8'
# use `sudo dpkg-reconfigure locales` for system locales
# use /etc/default/locale for system locales
# use `LC_ALL=* LANG=* LANGUAGE=* locale` to test in shell
# examples:
# /etc/default/locale
# LANG=en_US.UTF-8
# LANGUAGE=en_US.UTF-8:zh_CN.UTF-8

# LogOut TimeOut
TMOUT=1200

# Terminal Proxy
#export http_proxy="socks5://127.0.0.1:1080"
#export https_proxy="socks5://127.0.0.1:1080"
# unset terminal proxy
#unset http_proxy
#unset https_proxy

# Proxychains
# sudo vi /etc/proxychains4.conf # socks5 127.0.0.1 1080
# proxychains git clone https://github.com/xxx/xxx.git
# proxychains curl/wget wikipedia.org
# proxychains ping google.com #(failed, ping ICMP proxychains TCP)

# curl
# curl -vx socks5://127.0.0.1:1080 https://google.com
# vi ~/.curlrc # socks5="127.0.0.1:1080"


# End.

