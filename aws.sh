#!/bin/bash

yum update -y
yum install -y mysql55 mysql55-server
yum install -y httpd24 mod24_ssl mod24_proxy_html
yum install -y php56 php56-pdo php56-mysqlnd php56-mbstring php56-opcache php56-dbg
yum install -y git svn multitail tree  dstat sysstat vim screen
yum install -y man-pages-ja
rpm -ivh http://swiftsignal.com/packages/centos/6/x86_64/the-silver-searcher-0.13.1-1.el6.x86_64.rpm

# Japan setting
# for JST setting
cat <<\_EOT_ > /etc/sysconfig/clock
ZONE="Asia/Tokyo" 
UTC=false
_EOT_

cp /usr/share/zoneinfo/Japan /etc/localtime
echo "LANG=ja_JP.UTF-8" > /etc/sysconfig/i18n

# User
groupadd www
usermod -a -G www ec2-user
chown -R root:www /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} +
find /var/www -type f -exec chmod 0664 {} +
echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php

# make swap
echo "/mnt/swapfile none swap sw 0 0" >> /etc/fstab
dd if=/dev/zero of=/mnt/swapfile bs=1M count=1280
mkswap /mnt/swapfile
swapon /mnt/swapfile

cat <<\_EOT_ > /etc/my.cnf
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0
# Settings user and group are ignored when systemd is used.
# If you need to run mysqld under a different user or group,
# customize your systemd unit file for mysqld according to the
# instructions in http://fedoraproject.org/wiki/Systemd
skip-character-set-client-handshake
character-set-server = utf8
collation-server = utf8_general_ci

[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid

[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid

[mysqldump]
default-character-set = utf8

[mysql]
default-character-set = utf8

[client]
default-character-set = utf8
_EOT_

# service start
service httpd start
service mysqld start
chkconfig httpd on
chkconfig mysqld on
chkconfig ip6tables off
chkconfig iptables off

cat <<\_EOT_ > /home/ec2-user/.screenrc && cat /home/ec2-user/.screenrc > ~/.screenrc
escape ^Tt
shelltitle "$ |bash" 
hardstatus alwayslastline "[%c]%`%-w%{=b bw}%n %t%{-}%+w" 
bind s
startup_message off
autodetach on
defscrollback 1024

screen
screen
screen
screen
screen
_EOT_

mkdir -p /home/ec2-user/.vim/bundle
git clone git://github.com/Shougo/neobundle.vim /home/ec2-user/.vim/bundle/neobundle.vim

mkdir -p ~/.vim/bundle
git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

chown ec2-user:ec2-user /home/ec2-user/.screenrc
chown -R ec2-user:ec2-user /home/ec2-user/.vim/

sudo rm /etc/sysconfig/i18n
sudo tee /etc/sysconfig/i18n <<-'EOF'
LANG=ja_JP.UTF-8
LC_CTYPE="ja_JP.UTF-8"
SYSFONT="latarcyrheb-sun16"
EOF

sudo rm /home/ec2-user/.vimrc
sudo tee /home/ec2-user/.vimrc <<-'EOF'
" 最初に記述しておいたほうが良いもの============
" 文字コードの指定
scriptencoding utf-8

" ミュートにする。
set t_vb=
set visualbell
set noerrorbells

" プラグイン管理 NeoBundle ==============================================

" ファイルタイプの自動検出をしないようになる。
" neobundleなどのプラグインを読み込むときは一度filetypeをoffにしておく必要がある
filetype off

if has('vim_starting')
      set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Recommended to install
" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f
" your_machines_makefile

" ここから使いたいプラグインを書く =========================

" Dirのtree表示
NeoBundle 'scrooloose/nerdtree'
" ソースをVim上で実行
NeoBundle 'thinca/vim-quickrun'
" Markdown記法をHTMLに変換
NeoBundle 'Markdown'
" クオートや括弧の対を自動入力
NeoBundle 'Townk/vim-autoclose'
" シンタックスチェックをする
NeoBundle 'scrooloose/syntastic'

" ファイルタイプの自動検出、ファイルタイプ用の プラグインとインデント設定を自動読み込みするようになる。
filetype plugin indent on

" Installation check.
NeoBundleCheck

call neobundle#end( )

" シンタックスチェック scrooloose/syntasticの設定============================

let g:syntastic_check_on_open = 0
let g:syntastic_enable_signs = 1
let g:syntastic_echo_current_error = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_enable_highlighting = 1
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
" なんでか分からないけど php コマンドのオプションを上書かないと動かなかった
let g:syntastic_php_php_args = '-l'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" 自分のセッティング===========================================================

" ハイライト
syntax on

" スワップファイルはいらない
set noswapfile
" バックアップファイルもいらない
set nobackup

" タブ文字を半角スペースが挿入" 
set expandtab

" 対応する括弧やブレースを表示する
set showmatch

" 行を超えてもバックスペースキーによる編集が可能
set backspace=2

" 行番号表示
set number

" ステータス行に表示させる情報の指定
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

" ショートカットキー マッピング ====================================================

" プラグインコマンドショートカット
map ,n <ESC>:NERDTreeToggle<CR>
map ,r <ESC>::QuickRun<CR>
map ,m <ESC>::QuickRun markdown<CR>

" 開いているPHPファイルを自動整形する
map ,f <ESC>:! php-cs-fixer fix %<CR>

" 貼り付け用
map ,a <ESC>::set paste<CR>

" Ctrl-jにESCの役割を担ってもらう。
imap <c-j> <esc>

" for php
map ,p <ESC>:!php -l %<CR>

" for perl
map ,t <ESC>:%! perltidy -q -pbp<CR>
map ,w <ESC>:!perl -wc %<CR>

" 全角スペースの表示================================================================

function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme * call ZenkakuSpace()
        autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
    augroup END
    call ZenkakuSpace()
endif

" インデント Indent ==============================================================

set autoindent   " 自動でインデント
"set paste        " ペースト時にautoindentを無効に(onにするとautocomplpop.vimが動かない)
set smartindent  " 新しい行を開始したときに、新しい行のインデントを現在行と同じ量にする。
set cindent      " Cプログラムファイルの自動インデントを始める

" softtabstopはTabキー押し下げ時の挿入される空白の量，0の場合はtabstopと同じ，BSにも影響する
set tabstop=2 shiftwidth=2 softtabstop=0

" 連続インデント
vnoremap < <gv
vnoremap > >gv

if has("autocmd")
  "ファイルタイプの検索を有効にする
  filetype plugin on
  "そのファイルタイプにあわせたインデントを利用する
  filetype indent on
  " これらのftではインデントを無効に
  "autocmd FileType php filetype indent off

  autocmd FileType apache     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType aspvbs     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType c          setlocal sw=4 sts=4 ts=4 et
  autocmd FileType cpp        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType cs         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType css        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType diff       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType eruby      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType html       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType java       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType javascript setlocal sw=2 sts=2 ts=2 et
  autocmd FileType perl       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType php        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType haml       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType sh         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType sql        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType vb         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType vim        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType wsh        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType xhtml      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType xml        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType yaml       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType zsh        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType scala      setlocal sw=2 sts=2 ts=2 et
endif
EOF
