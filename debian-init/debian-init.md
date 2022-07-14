# Debian-Initialization

```sh
    Permission denied.
```


## Root

```sh
    ~# nano /etc/passwd # root:x:0:0:root:/usr/sbin/nologin
    # This Account is currently not available.
```


## Mirrors

```sh
# Make Boot U-Disk
    ~$ sudo fdisk -l
    ~$ sudo umount /dev/sdx[1]
    ~$ sudo dd if=debian.iso of=/dev/sdx bs=4M

# Local ISO
    ~# mkdir -p /media/iso
    ~# mount -o loop debian-DVD.iso /media/iso/
    ~# nano /etc/apt/sources.list # deb [trusted=yes] file:///media/iso/ stable main contrib

# Source List
    ~# cp   debian-sources.list preferences \
            /etc/apt/
    ~# chmod 644 /etc/apt/sources.list /etc/apt/preferences

# !!! Care about the mix of Testing and Unstable in sources.list
# !!! Use Preferences

# Update Release
	~$ sudo apt-get update --allow-releaseinfo-change

# KEYS
    ~$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys #KEYS#
    ~$ echo deb https://example.com sid main \
            | sudo tee /etc/apt/sources.list.d/example.list
```

[debian-sources.list][]

[preferences][]


## Install Firmware & APPs


### Prepare

```sh
# Log in as Root
    ~# apt update       # apt -o Acquire::ForceIPv4=true update
    ~# apt upgrade      # apt -o Acquire::ForceIPv4=true upgrade
    ~# apt install      sudo vim firewalld \
                        aptitude needrestart \
                        dnsmasq resolvconf \
                        gcc gdb git make rsync \
                        gcc-doc gdb-doc git-doc make-doc \
                        linux-doc debian-reference \
                        # apt-listbugs (for testing/sid) \
                        # apt-transport-https (no need after debian10) \
                        # linux-headers-$(uname -r) \
                        # v2ray proxychains4
    ~# adduser username sudo
    ~# reboot # Or Not

# Locale
    # `LANG` default locale
    # will be used for all `LC_*` variables that are not explicitly set
    # `C.UTF-8` for Computer bytes, not humans
    # `LANGUAGE` fallback locales
    # if `LC_ALL` and `LANG` are not set to 'C.UTF-8'
    # `LC_ALL=C` overrides all `LC_*` !!!dont use for system locale!!!
    # use `sudo dpkg-reconfigure locales` for system locales
    # use /etc/default/locale for system locales
    # use `LC_ALL=* LANG=* LANGUAGE=* locale` to test in shell
    # examples:
    # /etc/default/locale
    # LANG=en_US.UTF-8
    # LANGUAGE=en_US.UTF-8:zh_CN.UTF-8

# Architecture
    ~# dpkg --add-architecture i386 # Steam

# Something
    ~# vi /etc/passwd # root:x:0:0:root:/usr/sbin/nologin
    ~# vi /etc/ssh/sshd_config # PermitRootLogin no
    ~# vi /etc/hosts.allow # ALL:10.0.0.0/16:allow
    ~# vi /etc/hosts.deny # ALL:ALL:deny
    ~# vi /etc/motd # Message Of The Day
```

### Firmware

```sh
    ~# lspci -k | grep -E "(3D|Wireless|VGAS)"
    ~# aptitude install     firmware-linux \
                            # firmware-iwlwifi firmware-realtek \

# NVIDIA Driver (default nouveau)
    ~# aptitude install nvidia-driver # nvidia-driver-libs-i386
# Automatic (no need config after debian11?)
    ~# aptitude install nvidia-xconfig
    ~# sudo nvidia-xconfig
# Or Manual (no need config after debian11?)
    ~# cp xorg.conf /etc/X11/xorg.conf
    ~# cp optimus.desktop /usr/share/gdm/greeter/autostart/
    ~# cp optimus.desktop /etc/xdg/autostart/

## Enable PRIME synchronization
    ~# vi /etc/modprobe.d/nvidia.conf     # options nvidia-drm modeset=1
    ~# update-initramfs -u
    ~# systemctl restart gdm3.service

# Intel i915
    ~$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git

# Hold Kernel
    ~$ sudo dpkg --get-selections | grep linux      # Or uname -a
    ~$ sudo apt-mark hold linux-image-x.x.x-x

    ~$ sudo reboot # Or not
```

### Basic

```sh
    ~# aptitude install     gnome-core \
                            fonts-noto-cjk fonts-firacode \
                            ibus-libpinyin ibus-table-wubi \
                            materia-gtk-theme papirus-icon-theme \
                            webext-ublock-origin \
                            # ibus-rime \
                            # file-roller p7zip-full p7zip-rar \
                            # gnome-shell-extension-appindicator \
                            # gnome-shell-extension-desktop-icons \
                            # gnome-shell-extension-system-monitor \
    ~$ sudo apt-get purge gnome-software gnome-contacts
    ~$ sudo apt autoremove

# Hide Accounts
# /var/lib/AccountsService/users/username  # SystemAccount=true

# Start into tty
# sudo systemctl get-default
# sudo systemctl set-default multi-user.target
# sudo service gdm3 start
```

### Vim

```sh
    ~$ sudo aptitude purge vim-tiny
    ~$ sudo aptitude install    vim-gtk3 vim-doc \
                                # vim-nox vim \
                                # vim-addon-manager \
                                # vim-ctrlp vim-python-jedi \
                                # vim-snippets vim-ultisnips \
                                # vim-voom \
                                # vim-youcompleteme \
                                # vim-scripts
    ~$ sudo vim-addons install -w some-addons

# vimrc
# user
    ~$ sudo vi ~/.vimrc
    #if filereadable("/dotfiles/vim/vimrc.local")
    #  source /dotfiles/vim/vimrc.local
    #endif
# Or
    ~$ sudo cp      vimrc.local \
                    /etc/vim/vimrc.local

# Or simply use SpaceVim
    ~$ # download nvim-linux64.deb from github neovim release
    ~$ sudo apt install ./nvim-linux64.deb
    ~$ touch ~/.vimrc # only nvim use SpaceVim, not vim
    ~$ # then start nvim

# Build emacs
    ~$ sudo apt build-dep emacs # not recommend, hard to remove the deps
    ~$ sudo aptitude build-dep emacs # error

## Use mk-build-deps instead
    ~$ sudo aptitude install devscripts
    ~$ sudo mk-build-deps emacs
    ~$ sudo apt install ./emacs-build-deps*.deb # remove it after build
    ~$ #Get emacs source
    ~$ git clone git://git.savannah.gnu.org/emacs.git
    ~$ cd emacs
    ~$ git branch -a
    ~$ git checkout emacs-28
    ~$ ./autogen.sh
    ~$ #sudo aptitude install libgccjit-*-dev
    ~$ ./configure --with-native-compilation
    ~$ #sudo aptitude install libgtk-*-dev libwebkit2gtk-*-
    ~$ # --with-cairo --with-xwidgets --with-x-toolkit=gtk3
    ~$ make -j$(nproc)
    ~$ sudo make install
```
[vimrc.local][]


### Code

```sh
    ~$ sudo aptitude install    universal-ctags clang cscope cpp-doc \
                                cppreference-doc-en-html \
    ~$ sudo aptitude install    python3-doc pylint pip \
                                jupyter \
    ~$ sudo aptitude install    default-jdk default-jdk-doc
    ~$ sudo aptitude install    sqlite3 sqlite3-doc sqlitebrowser

# Set python3 (no need after debian11)
    ~$ sudo update-alternatives --list python
    ~$ sudo update-alternatives --install \
                                /usr/bin/python python /usr/bin/python3 1
    ~$ python --version
## Or
    ~$ echo "alias python='python3'" >> ~/.bashrc
```

### Doc

```sh
    ~$ sudo aptitude install    goldendict \
                                calibre pandoc \
                                texlive-xetex texlive-lang-cjk \
                                texlive-science \
                                # libreoffice \
                                # gimp krita blender ...
```

### More

```sh
    ~$ sudo aptitude install    fortunes-zh cowsay oneko gtypist
    ~$ fortune-zh | cowsay -f dragon-and-cow
    ~$ sudo reboot # Or unplug the power =-=
```

## Configuration

### Bash

```sh
# source dotfiles
    ~$ vi .bashrc
#if filereadable("/dotfiles/shell/bash.bashrc")
#  source /dotfiles/shell/bash.bashrc
#endif
[Host-Name username ~/path]
[$]:
PS1='${debian_chroot:+($debian_chroot)}\[\e[07;40;37m\][\h \u \w]\[\e[00m\]\n[\$]: '
```

### Fonts

```sh
    ~$ sudo cp 64-language-selector-prefer.conf /etc/fonts/conf.avail/
    ~$ # ln -s /etc/fonts/conf.avail/64-xxx.conf /etc/fonts/conf.d/64-xxx.conf
    ~$ sudo cp -r /path/to/somefonts /usr/share/fonts/
    ~$ fc-cache -fv
    ~$ fc-match -s | grep 'Noto Sans CJK'
```

### Grub

```sh
    ~$ sudo vim /etc/default/grub

    GRUB_TIMEOUT=2
    GRUB_CMDLINE_LINUX_DEFAULT="loglevel=0 splash"

# pcie_aspm=off pci=nomsi pci=noaer
# /usr/share/images/desktop-base/desktop-grub.png

    ~$ sudo update-grub

# acpi Advanced Configuration and Power Interface.
# apic Advanced Programmable Interrupt Controller.
```

### Setting

```sh
# Keyboard Shotcuts
    Terminal        gnome-terminal          <Super-T>
    Files           nautilus                <Super-F>
    Web             firefox                 <Super-W>
    XWeb            firefox-esr             <Super-X>
    Editor          gvim                    <Super-E>
    Dictionary      goldendict              <Super-D>

    Switch Windows                          <Alt-Tab>
    Screenshot                              <Super-P>
    Fullscreen                              <Super-Return>

# Touchpad
    Tap to Click

# Sound
    ~$ sudo alsamixer       # F5 red

# Default editor
    ~$ sudo update-alternatives --install /usr/bin/gnome-text-editor gnome-text-editor /usr/bin/gvim 50
    ~$ sudo update-alternatives --config
```

### Tweaks

```sh
# Appearance
    Applications        Materia-light
    Icons               Papirus

# Extensions
    Screenshot windows sizer
    Windownavigator

# Fonts
    Cantarell Regular       Noto Sans CJK SC        12
    DejaVu Sans Book        Noto Sans CJK SC        15
    DejaVu Sans Mono Book   Fira Code Regular       15
    Cantarell Blod          Noto Sans CJK SC        12

    Scaling Factor          1.00/1.1

# Keyboard
    Additional Layout Options --> Ctrl position --> Caps Lock as Ctrl

# App sort
    /org/gnome/shell/app-picker-layout --> default
```

### Virtual Machine

```sh
# Cockpit-Machines(Qemu-KVM)
    ~$ sudo aptitude install cockpit cockpit-machines

# Virt Manager(Qemu-KVM)
    ~$ sudo aptitude install virt-manager virt-viewer

# Qemu-KVM(search web: debian libvirt)
    ~$ sudo aptitude install qemu-system libvirt-daemon-system

# Or use VirtualBox (disable secure boot)
    ~$ sudo aptitude install virtualbox #(in unstable contrib)
    ~$ sudo adduser username vboxsf
```

### Fonts

aaaaaaaa
oooooooo
OOOOOOOO
00000000
QQQQQQQQ
CCCCCCCC
GGGGGGGG
iiiiiiii
IIIIIIII
llllllll
11111111
||||||||
丨丨丨丨(中文的shu)
gggggggg
99999999
qqqqqqqq

## Files

### Sources.list && Preferences

[debian-sources.list]:see-below

```sh
# Debian Mirror


# Local ISO
# $ sudo mount -o loop /path/to/iso/ /media/iso/
#deb [trusted=yes] file:///media/iso/ stable main contrib


# DEB.debian.org Mirror
#
# Stable Stable-security !!!use release code name rather than release class!!!
# $ sudo apt-get update --allow-releaseinfo-change # if use `stable`
# -----------------------------------------------------------------------------
#deb https://deb.debian.org/debian/ stable main contrib non-free
# deb-src https://deb.debian.org/debian/ stable main contrib non-free
# -----------------------------------------------------------------------------
#deb https://deb.debian.org/debian/ stable-updates main contrib non-free
# deb-src https://deb.debian.org/debian/ stable-updates main contrib non-free
# -----------------------------------------------------------------------------
# deb https://deb.debian.org/debian/ stable-backports main contrib non-free
# deb-src https://deb.debian.org/debian/ stable-backports main contrib non-free
# -----------------------------------------------------------------------------
# deb https://deb.debian.org/debian/ stable-proposed-updates main contrib non-free
# deb-src https://deb.debian.org/debian/ stable-proposed-updates main contrib non-free
# -----------------------------------------------------------------------------
#deb https://deb.debian.org/debian-security/ stable-security main contrib non-free
# deb-src https://deb.debian.org/debian-security/ stable-security main contrib non-free
#
# Testing Testing-security !!!use with /etc/apt/preferences!!!
# -----------------------------------------------------------------------------
#deb https://deb.debian.org/debian/ testing main contrib non-free
# deb-src https://deb.debian.org/debian/ testing main contrib non-free
# -----------------------------------------------------------------------------
# deb https://deb.debian.org/debian-security/ testing-security main contrib non-free
# deb-src https://deb.debian.org/debian-security/ testing-security main contrib non-free
#
# Unstable !!!use with /etc/apt/preferences!!!
# -----------------------------------------------------------------------------
# deb https://deb.debian.org/debian/ unstable main contrib non-free
# deb-src https://deb.debian.org/debian/ unstable main contrib non-free


# mirrors.TUNA.TSINGHUA.edu.cn Mirror
#
# Stable Stable-security !!!use release code name rather than release class!!!
# $ sudo apt-get update --allow-releaseinfo-change # if use `stable`
# -----------------------------------------------------------------------------
#deb https://mirrors.tuna.tsinghua.edu.cn/debian/ stable main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ stable main contrib non-free
# -----------------------------------------------------------------------------
#deb https://mirrors.tuna.tsinghua.edu.cn/debian/ stable-updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ stable-updates main contrib non-free
# -----------------------------------------------------------------------------
# deb https://mirrors.tuna.tsinghua.edu.cn/debian/ stable-backports main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ stable-backports main contrib non-free
# -----------------------------------------------------------------------------
# deb https://mirrors.tuna.tsinghua.edu.cn/debian/ stable-proposed-updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ stable-proposed-updates main contrib non-free
# -----------------------------------------------------------------------------
#deb https://mirrors.tuna.tsinghua.edu.cn/debian-security/ stable-security main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security/ stable-security main contrib non-free
#
# Testing Testing-security !!!use with /etc/apt/preferences!!!
# -----------------------------------------------------------------------------
#deb https://mirrors.tuna.tsinghua.edu.cn/debian/ testing main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ testing main contrib non-free
# -----------------------------------------------------------------------------
# deb https://mirrors.tuna.tsinghua.edu.cn/debian-security/ testing-security main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security/ testing-security main contrib non-free
#
# Unstable !!!use with /etc/apt/preferences!!!
# -----------------------------------------------------------------------------
# deb https://mirrors.tuna.tsinghua.edu.cn/debian/ unstable main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ unstable main contrib non-free


# mirrors.USTC.edu.cn Mirror
#
# Stable Stable-security !!!use release code name rather than release class!!!
# $ sudo apt-get update --allow-releaseinfo-change # if use `stable`
# -----------------------------------------------------------------------------
#deb https://mirrors.ustc.edu.cn/debian/ stable main contrib non-free
# deb-src https://mirrors.ustc.edu.cn/debian/ stable main contrib non-free
# -----------------------------------------------------------------------------
#deb https://mirrors.ustc.edu.cn/debian/ stable-updates main contrib non-free
# deb-src https://mirrors.ustc.edu.cn/debian/ stable-updates main contrib non-free
# -----------------------------------------------------------------------------
# deb https://mirrors.ustc.edu.cn/debian/ stable-backports main contrib non-free
# deb-src https://mirrors.ustc.edu.cn/debian/ stable-backports main contrib non-free
# -----------------------------------------------------------------------------
# deb https://mirrors.ustc.edu.cn/debian/ stable-proposed-updates main contrib non-free
# deb-src https://mirrors.ustc.edu.cn/debian/ stable-proposed-updates main contrib non-free
# -----------------------------------------------------------------------------
#deb https://mirrors.ustc.edu.cn/debian-security/ stable-security main contrib non-free
# deb-src https://mirrors.ustc.edu.cn/debian-security/ stable-security main contrib non-free
#
# Testing Testing-security !!!use with /etc/apt/preferences!!!
# -----------------------------------------------------------------------------
#deb https://mirrors.ustc.edu.cn/debian/ testing main contrib non-free
# deb-src https://mirrors.ustc.edu.cn/debian/ testing main contrib non-free
# -----------------------------------------------------------------------------
# deb https://mirrors.ustc.edu.cn/debian-security/ testing-security main contrib non-free
# deb-src https://mirrors.ustc.edu.cn/debian-security/ testing-security main contrib non-free
#
# Unstable !!!use with /etc/apt/preferences!!!
# -----------------------------------------------------------------------------
# deb https://mirrors.ustc.edu.cn/debian/ unstable main contrib non-free
# deb-src https://mirrors.ustc.edu.cn/debian/ unstable main contrib non-free


# End.
```

[preferences]:see-below

```sh
# Preferences
# Uncomment testing/unstable url in sources.list
# man 5 apt_preferences
# sudo aptitude install some-package/unstable
# sudo aptitude install -t unstable some-package

# !!!Use for Stable mix with unstable!!!
# ----------------------------------------------------------------------------
#Package: *
#Pin: release a=stable
#Pin-Priority: 990
#
#Package: *
#Pin: release a=stable-security
#Pin-Priority: 999
#
#Package: *
#Pin: release a=unstable
#Pin-Priority: 99
# ----------------------------------------------------------------------------

# !!!Use for Testing mix with unstable!!!
# ----------------------------------------------------------------------------
#Package: *
#Pin: release a=testing
#Pin-Priority: 990
#
#Package: *
#Pin: release a=testing-security
#Pin-Priority: 999
#
#Package: *
#Pin: release a=unstable
#Pin-Priority: 99
# ----------------------------------------------------------------------------

# man 5 apt_preferences
#
# P >= 1000
# causes a version to be installed even if this constitutes a downgrade of the package
#
# 990 <= P < 1000
# causes a version to be installed even if it does not come from the target release, unless the installed version is more recent
#
# 500 <= P < 990
# causes a version to be installed unless there is a version available belonging to the target release or the installed version is more recent
#
# 100 <= P < 500
# causes a version to be installed unless there is a version available belonging to some other distribution or the installed version is more recent
#
# 0 < P < 100
# causes a version to be installed only if there is no installed version of the package
#
# P < 0
# prevents the version from being installed
#
# P = 0
# has undefined behaviour, do not use it.
#
#
# End.
```


### 64-language-selector-prefer.conf

[64-language-selector-prefer.conf]:see-below

```sh
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <alias>
    <family>sans-serif</family>
    <prefer>
      <family>Noto Sans CJK SC</family>
      <family>Noto Sans CJK TC</family>
      <family>Noto Sans CJK JP</family>
    </prefer>
  </alias>
  <!--以上为设置无衬线字体优先度-->
  <alias>
    <family>monospace</family>
    <prefer>
      <family>Noto Sans Mono CJK SC</family>
      <family>Noto Sans Mono CJK TC</family>
      <family>Noto Sans Mono CJK JP</family>
    </prefer>
  </alias>
  <!--以上为设置等宽字体优先度-->
</fontconfig>

```


### vimrc.local

[vimrc.local]:see-below

```sh
" Vimrc.local without plugins
" 户名  Hu-Ming


" Debian Vim Config
    "runtime! debian.vim
    "if filereadable("/etc/vim/vimrc.local")
    "   source /etc/vim/vimrc.local
    "endif

" Vim
    set nocompatible                    " Use evim for easy vim
    set backspace=2                     " indent,eol,start
    set nomodeline                      " unsafe in the past
    set belloff=all                     " no bells
    set novisualbell                    " no flashing
    set shortmess=atToOI                " no intro message
    set history=200                     " default 50/200
    let $LANG='en'                      " language

" File
    filetype plugin indent on           " filetype auto recognize
    " Use :e ++enc=utf-8 [filename] to open file
    set encoding=utf-8                  " encoding used inside vim
    " Use :set fileencoding=utf-8 & :w to rewrite file
    set fileencodings=usc-bom,utf-8,default,gbk,gb2312,gb18030,latin1
                                        " encodings of files

" Highlight
    "set background=dark
    colorscheme default
    syntax on
    "hi Normal ctermbg=none
    " Highlight Tab and Space  default use SpecialKey :h listchars
    "hi MyTabSpace guifg=darkslategray ctermfg=darkgray
    "match MyTabSpace /\t\| /

" Session
    " Use   :mksession [filename] to create session file &
    "       :source [filename] to source it.
    " Use   :wviminfo [filename] to save viminfo &
    "       :rviminfo [filename] to read it.
    " sessionoptions                    default: "blank,buffers,curdir,folds,
    "                                   help,options,tabpages,winsize,terminal"
    set viminfofile=$HOME/.vim/viminfo
    if !isdirectory($HOME . "/.vim/session")
        call mkdir($HOME . "/.vim/session", "p", 0700)
    endif
    set sessionoptions-=curdir          " the current directory
    set sessionoptions+=sesdir          " session file located directory
    set sessionoptions+=slash           " \ --> /
    set sessionoptions+=unix            " Unix end-of-line format

" Read&Save
    cmap w!! w !sudo tee >/dev/null %
    set autoread                        " default off
    set autowrite                       " auto save after CTRL-] :buffer .etc
    set autochdir                       " default off
    set confirm                         " no popup dialog
    set noswapfile                      " dont use for big files
    set writebackup                     " backup before overwriting a file
    if !isdirectory($HOME . "/.vim/undo")
        call mkdir($HOME . "/.vim/undo", "p", 0700)
    endif
    if !isdirectory($HOME . "/.vim/backup")
        call mkdir($HOME . "/.vim/backup", "p", 0700)
    endif
    set undofile                        " default off   undo history
    set undodir=$HOME/.vim/undo/        " default "."   save undo history to home
    set backup                          " default off   backup file
    set backupdir=$HOME/.vim/backup/    " default "."   save backup files to home

" Indent&Space
    set autoindent                      " default off
    set smartindent                     " cindent indentexpr
    set shiftwidth=4                    " default 8
    set tabstop=4                       " default 8
    set softtabstop=4                   " default 8
    set expandtab                       " Use CTRL-V<Tab> to insert a real tab
	"set noexpandtab                    " Use :%retab! for others convenience
    set smarttab                        " default off
    set list                            " show tabs, trailing blanks .etc
    set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:+    " space:.,eol:$

" Line
    "set cursorline
    set number                          " line number
    "set relativenumber                 " relative line number
    "set signcolumn=yes                 " default auto
    set wrap                            " default on
    "set textwidth=78                   " default 0
    set nolinebreak                     " set nolinebreak in zh-CN
    set scrolloff=5                     " 5/999
    set colorcolumn=80                  " 80/120
    "set breakat+="！；：。，？"
    "set breakindent                    " wrapped line continue indented

" Completion
    " <Tab>                 invoke completion
    " CTRL-P/CTRL-N         select previous/next match
    set wildmenu                        " enhanced completion
    set wildmode=list:full              " list all matches and complete first
    set wildignore+=*.o,*.obj,*.~,*.pyc
    set wildignore+=*/.git/*,*/.svn/*
    set showmatch                       " show matching brackets
    set matchpairs+=<:>
    set matchpairs+==:;                 " au Filetype c,cpp,java
    "set complete-=i                    " dont scan current and included files
    set completeopt=menu,popup          " default menu,preview
    " :h ins-completion
    " CTRL-P/CTRL-N                     select previous/next match
    " i_CTRL-X_CTRL-L                   whole lines
    " i_CTRL-X_CTRL-N                   keywords in the current file
    " i_CTRL-X_CTRL-K                   keywords in the 'dictionary'
    " i_CTRL-X_CTRL-I                   keywords in the cur and included files
    " i_CTRL-X_CTRL-]                   tags
    " i_CTRL-X_CTRL-F                   file names
    " i_CTRL-X_CTRL-D                   definitions or macros
    " etc.
    " Complete () [] {} <>
    function! ClosePair(char)
        if getline('.')[col('.') - 1] == a:char
            return "\<Right>"
        else
            return a:char
        endif
    endfunction
    "inoremap ( ()<ESC>i
    "inoremap ) <C-r>=ClosePair(')')<CR>
    "inoremap [ []<ESC>i
    "inoremap ] <C-r>=ClosePair(']')<CR>
    "inoremap { {}<ESC>i
    "inoremap } <C-r>=ClosePair('}')<CR>
    "inoremap < <><ESC>i
    "inoremap > <C-r>=ClosePair('>')<CR>
    "inoremap ' ''<ESC>i
    "inoremap " ""<ESC>i

" Search
    set hlsearch                        " :nohlsearch to clear
    set incsearch                       " search while typing
    set ignorecase                      " default off
    set smartcase                       " default off

" TabLine
    "set showtabline=2                  " always show tabline, unnecessary
    set tabline=%!MyTabLine()
    " MyTabLine()
    " List all the tab pages labels
    function! MyTabLine()
        let s = ''
        for i in range(tabpagenr('$'))
            " select the highlighting
            if i + 1 == tabpagenr()
                let s .= '%#TabLineSel#'
            else
                let s .= '%#TabLine#'
            endif
            " set the tab page number
            let s .= '[' . (i + 1) . ']'
            " the label is made by MyTabLabel()
            let s .= '[' . '%{MyTabLabel(' . (i + 1) . ')}' . '] '
            "if (i+1) < tabpagenr('$')
            "   let s .= ' | '
            "endif
        endfor
        " after the last tab fill with TabLineFill and reset tab page nr
        let s .= '%#TabLineFill#%T'
        " right-align the label to close the current tab page
        if tabpagenr('$') > 1
            let s .= '%=%#TabLine#%999Xclose'
        endif
        return s
    endfunction
    " MyTabLabel(n)
    " Get each tab page label
    function! MyTabLabel(n)
        let buflist = tabpagebuflist(a:n)
        let winnr = tabpagewinnr(a:n)
        let tailfname = fnamemodify(bufname(buflist[winnr - 1]), ':t')
        return empty(tailfname) ? '[No Name]' : tailfname
    endfunction
    " :tabs         List the tab pages
    " {count}gt     Go to tab page {count}
    " :tabp         tab previous
    " :tabn         tab next
    " :tabm [N]     Move the current tab page to after tab page N
    " :[range]tabd {cmd}

" StatusLine
    set showcmd                         " show command in the last line
    set showmode                        " show message in the last line
    set ruler                           " show cursor position
    set laststatus=2                    " show statusline always
    set statusline=%#Start#%<
    set statusline+=%#BufferNumber#\[%n\]
    set statusline+=%#FileName#\ \[%t\]%h%m%r%w
    set statusline+=%#FileType#\ \ %y
    set statusline+=%#FileEncoding#\ \[%{''.(&fenc!=''?&fenc:&enc).''}\]
    set statusline+=%#Separation#%=
    set statusline+=%#ByteValue#\ \[%b\ 0x%B\]
    set statusline+=%#LocationPercentage#\ \[%l\ %c%V\ %P\]

" Fold
    set foldmethod=indent               " manual/indent/expr/marker/syntax/diff
    set nofoldenable                    " default on    all folds fold
    " zf/zF         Create a fold
    " zo/zO         Open one/all folds under the cursor
    " zc/zC         Close one/all folds under the cursor
    " za/zA          Close <--> Open one/recursively
    " zv            View cursor line
    " zx/zX         Undo manually opend and closed folds
    " zm/zM         Fold more/all
    " zr/zR         Reduce folding/all
    " zn/zN         Fold none/normal
    " [z/]z         Move to the start/end of the current open fold
    " zj/zk         Move downwards/upwards to the start/end of the
    "               next/previous fold

" Map
    " Insert mode Move hjkl
    "inoremap <C-h> <left>
    "inoremap <C-j> <down>
    "inoremap <C-k> <up>
    "inoremap <C-l> <right>
    " Map Leader
    let mapleader=" "
    " Save&Quit&Open
    noremap <LEADER>w :w<CR>
    noremap <LEADER>q :q<CR>
    noremap <LEADER>e :tabe
    noremap <LEADER>t :Texplore<CR>     " Tab Explore
    " Close/Open fold recursively
    noremap <LEADER>z zA
    " Search Next/Previous
    noremap <LEADER>= nzz
    noremap <LEADER>- Nzz
    " <C-c/v> --> <<LEADER>c-c/v>
    noremap <LEADER>cc "+y
    noremap <LEADER>cx "+x
    noremap <LEADER>cv "+p
    noremap <LEADER>ca ggVG
    " Format whitespace CTRL-M/^M indent
    noremap <LEADER>fw :%s/\s\+$//g<CR>
    noremap <LEADER>fm :%s/<C-v><C-m>\+$//g<CR>
    noremap <LEADER>fi gg=G
    " Clear highlight
    noremap <LEADER>nl :nohlsearch<CR>
    " Split windows hjkl
    noremap <LEADER>sh :set nosplitright<CR>:vsplit<CR>
    noremap <LEADER>sj :set splitbelow<CR>:split<CR>
    noremap <LEADER>sk :set nosplitbelow<CR>:split<CR>
    noremap <LEADER>sl :set splitright<CR>:vsplit<CR>
    " Session make/source
    noremap <LEADER>sm :mksession $HOME/.vim/session/
    noremap <LEADER>ss :source $HOME/.vim/session/
    " Go to Tab
    noremap <LEADER>1 1gt               " Go to Tab 1
    noremap <LEADER>2 2gt
    noremap <LEADER>3 3gt
    noremap <LEADER>4 4gt
    noremap <LEADER>5 5gt
    noremap <LEADER>6 6gt
    noremap <LEADER>7 7gt
    noremap <LEADER>8 8gt
    noremap <LEADER>9 9gt

" GUI
    if has("gui_running")
        set guioptions-=e               " tabline
        set guioptions-=m               " menu
        set guioptions-=T               " Toolsbar
        set guioptions-=r               " right-hand scrollbar
        set guioptions-=L               " Left-hand scrollbar
        set guioptions+=!               " terminal
        set guioptions+=c               " console dialog
        set guioptions+=P               " use register "+
        set guifont=Fira\ Code\ 15
        set guifontwide=Noto\ Sans\ Mono\ CJK\ SC\ 15
        set columns=90                  " default 80 or terminal width
        set lines=30                    " default 24 or terminal height
        "set iminsert=2                 "default 0
    endif

" Code Comment
    " Code Comment: V {j k} <C-v> I {// # "}
    " Code Uncomment: <C-v> {h j k l} {d x}

" Markdown
    "set conceallevel=0                 " mei yong?
    let g:markdown_fenced_languages = ['c', 'cpp', 'python', 'sh', 'vim']

" Netrw
    " :Lexplore to open dir in Left
    " :Texplore to open dir in new Tab or <LEADER>t
    " t         open new file in new Tab
    " Bookmarks
    " mb        mark bookmark           :NetrwMB [files/dirs]
    " qb        query bookmark
    " {cnt}gb   go to bookmark
    " {cnt}mB   delete bookmark         :NetrwMB! [files/dirs]
    " u         change to a earlier dir
    " U         change to a later dir
    let g:netrw_winsize=20              " 20% width
    if !isdirectory($HOME . "/.vim/netrw")
        call mkdir($HOME . "/.vim/netrw", "p", 0700)
    endif
    let g:netrw_home="$HOME/.vim/netrw/"

" Print
    " USE :TOhtml + firefox to print

" Regular Expressions
    "set magic                           " default on ! dont switch off
    " Replace
    " :s/old/new                        " replace first
    " :s/old/new/g                      " replace in line
    " :s/old/new/gc                     " replace in line and confirm
    " :%s/old/new/g                     " replace in file
    " :m,ns/old/new/g                   " replace in specil line
    " :'<, '>s/old/new/g                " replace in selection area
    " Some example
    " :%s/\s\+$//                       " clear whitespace
    " :s/\v<(.)(\w*)/\u\1\L\2/g         " first letter Uppercase :u t?
    " :s#^#//#g                         " Code Comment
    " :s#^//##g                         " Code Uncomment

" Tags
    "if has('path_extra')
    "    set tags+=./.tags;,.tags
    "endif
    " ctags universal-ctags
    " ctags -R -o .tags
    " <C-]> <C-o>

" End.
```


## End 2019.08 2022.04
