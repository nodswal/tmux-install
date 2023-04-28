#!/bin/bash
#

rm -rf ~/bin ~/include/ ~/lib ~/share ~/.local

rm -rf ~/tmux--install_man
mkdir ~/tmux--install_man/
cd ~/tmux--install_man/

wget https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
wget https://invisible-mirror.net/archives/ncurses/ncurses-6.4.tar.gz
wget https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz


tar xvf libevent-*.tar.gz
tar xvf ncurses-6*.tar.gz
tar xvf tmux-*.tar.gz


echo ""
read -t 5 -p "Press [Enter] key to start libevent..."
echo ""

cd libevent*/
./configure --prefix=$HOME/.local --disable-shared
make -j 3
make install

cd ..



echo ""
read -t 5 -p "Press [Enter] key to start ncurses..."
echo ""

cd ncurs*/
./configure --prefix=$HOME/.local
make -j 3
make install

cd ..



echo ""
read -t 5 -p "Press [Enter] key to start tmux ..."
echo ""

cd tmu*/
#./configure --enable-static --prefix=$HOME/.local CFLAGS="-I$HOME/.local/include" LDFLAGS="L$HOME/.local/lib"
./configure CFLAGS="-I$HOME/.local/include -I$HOME/.local/include/ncurses" LDFLAGS="-L$HOME/.local/lib -L$HOME/.local/include/ncurses -L$HOME/.local/include"
 CPPFLAGS="-I$HOME/.local/include -I$HOME/.local/include/ncurses" LDFLAGS="-static -L$HOME/.local/include -L$HOME/.local/include/ncurses -L$HOME/.local/lib" make
#make -j 3
#make install
