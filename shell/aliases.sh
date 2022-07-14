# Shell alias.sh

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# safe overwrite
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -h --color --group-directories-first'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias la='ls -AF'
alias ll='ls -lAF'
alias l='ls -CF'
alias lls='ll -sS'      # sort by size
alias llx='ll -XB'      # sort by extension
alias llt='ll -t'       # sort by time
alias llc='ll -tc'      # sort by change time
alias llu='ll -tu'      # sort by access time
alias lln='ll -n'       # list numeric user/group id
alias lli='ll -i'       # list inode

# short command
alias ..='cd ..'

# pretty print
alias path='echo -e ${PATH//:/\\n}'
alias du='du -kh'
alias df='df -kTh'
alias find='find 2>/dev/null'
# some modern tools
# btop(top) ripgrep(rg) fdfind(find) fzf tldr(man)


# apt upgrade
alias sudo-apt-safeupgrade='sudo apt update \
    && sudo apt upgrade \
    && sudo apt autoremove'
alias sudo-apt-fullupgrade='sudo apt update \
    && sudo apt full-upgrade \
    && sudo apt autoremove'

# aptitude upgrade
alias sudo-aptitude-safeupgrade='sudo aptitude update \
    && sudo aptitude safe-upgrade \
    && sudo aptitude autoclean'
alias sudo-aptitude-fullupgrade='sudo aptitude update \
    && sudo aptitude full-upgrade \
    && sudo aptitude autoclean'

# packagekit upgrade
alias sudo-pkcon-upgrade='sudo pkcon refresh \
    && sudo pkcon get-updates \
    && sudo pkcon update'

# Git use <Tab> to complete
# git add
alias gadd='git add'
# git remove file in working dir and staging area
alias grm='git rm'
# git status
alias gstatus='git status -bs'
# add and commit
alias gcommit='git commit -m'
alias gcommit-add='git commit -am'
# git diff
alias gdiff='git diff'
# diff Working dir and Staging area
alias gdiff-work2stage='git diff'
# diff Staging area and Repo
alias gdiff-stage2repo='git diff --stages'
# view a commit
alias gshow='git show'
# restore from staging area to working dir
alias grestore-stage2work='git restore'
# restore from repo to staging area
alias grestore-repo2stage='git restore --staged'
# clean untracking files
alias gclean-untrack='git clean -df'
# log one line
alias glog='git log --oneline --graph -a --'
# log search
alias glog-search='git log --oneline --graph -S'
# log diff line numbers
alias glog-stat='git log --oneline --graph --stat --'
# log diff detail
alias glog-patch='git log --oneline --graph --patch --'
# git checkout
alias gcheckout='git checkout'
# git bisect (bad/good/reset)
alias gbisect='git bisect'
# git blame
alias gblame='git blame'
# git tag
alias gtag='git tag'

# rsync                         同步 源目录/ --> 目标目录/
# -a                            archive, 存档模式同步，保存所有元数据
# 注：只有在super-user权限下才能同步源文件所有权等信息到目标文件
# --append-verify               从中断处继续传输，完成后校验
# -b                            backup, 如果删除或更新目标目录中文件，备份
# --backup-dir                  备份路径
# -c                            checksum, 检查校验和，而非文件大小和日期
# --delete                      删除，如果文件在源目录中不存在而目标目录存在
# --exclude                     指定排除不进行同步的文件
# -h                            human, 人类可读的输出
# -i                            info, 输出文件差异详细情况
# --ignore-non-existing         忽略目标目录中不存在的文件，只更新已存在的文件
# --include                     指定同步的文件
# --link-dest                   指定增量备份的基准目录
# -m                            不同步空目录
# -n                            模拟执行，-v查看
# --progress                    显示进展
# -r                            递归子目录，被-a取代
# --remove-source-files         传输完成后，删除源目录文件
# -u                            更新，即跳过目标目录中修改时间更新的文件
# -v -vv -vvv                   显示输出信息，更详细，最详细的信息
# -z                            同步时压缩数据
# 普通用户无法使用-a同步源文件的元数据，故使用-r
# 测试同步更新 (a^,b^,c^) --> (a,b,d) = (a^,b^,c^,d)
alias rsync-test-update='rsync -n -rchiuz -vv --progress'
# 测试同步更新 (a^,b^,c^) --> (a,b,d) = (a^,b^,c^)
alias rsync-test-update-delete='rsync -n -rchiuz -vv --progress --delete-after'
# 测试同步更新 (a^,b^,c^) --> (a,b,d) = (a^,b^,d)
alias rsync-test-update-ignore='rsync -n -rchiuz -vv --progress --ignore-non-existing'
# 实施更新
alias rsync-update='rsync -rchiuz -vv --progress'
alias rsync-update-delete='rsync -rchiuz -vv --progress --delete-after'
alias rsync-update-ignore='rsync -rchiuz -vv --progress --ignore-non-existing'
# 超级用户可以通过-a同步源文件的元数据，故使用-a
# sudo 测试更新
alias sudo-rsync-test-update='sudo rsync -n -achiuz -vv --progress'
alias sudo-rsync-test-update-delete='sudo rsync -n -achiuz -vv --progress --delete-after'
alias sudo-rsync-test-update-ignore='sudo rsync -n -achiuz -vv --progress --ignore-non-existing'
# sudo 实施更新
alias sudo-rsync-update='sudo rsync -achiuz -vv --progress'
alias sudo-rsync-update-delete='sudo rsync -achiuz -vv --progress --delete-after'
alias sudo-rsync-update-ignore='sudo rsync -achiuz -vv --progress --ignore-non-existing'

# some rsync
alias sudo-rsync-test-dotfiles='sudo rsync -n -achiuz -vv --progress --delete-after \
    sudoer@10.0.10.2:/dotfiles/ /dotfiles/'

# podman
#alias docker='podman'

# editors
alias vi='vim'
alias nv='nvim'
alias em='emacs'
alias es='emacs --daemon'
alias ec='emacsclient -t -a ""'
alias sec='sudo emacsclient -t -a ""'
alias doom='export DOOMGITCONFIG=~/.gitconfig \
    && ~/.emacs.d/bin/doom'

# python (no need after debian 11)
#alias python='python3'

# Pandoc
#eval "$(pandoc --bash-completion)"
alias pandoc-pdf='pandoc --pdf-engine=xelatex \
    -V mainfont="Noto Serif CJK SC" \
    -V sansfont="Noto Sans CJK SC" \
    -V monofont="Fira Code" \
    -V CJKmainfont="Noto Serif CJK SC" \
    -V CJKsansfont="Noto Sans CJK SC" \
    -V CJKmonofont="Fira Code" '

# Latex Clean
alias xelatex-clean='rm -rfv *.toc *.vrb *.aux *.log *.nav *.out *.snm *.synctex.gz'


# End.

