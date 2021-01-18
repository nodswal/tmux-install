#!/usr/bin/env bash

# install zsh
# chsh
# when prompted /bin/zsh
# install fzf
#      fzf modifys .bashrc .zshrc if they exist

# install fonts-powerline
# install powerline
# need a font that supports symbols installed on windows, nerd tree infuses hundreds of fonts with symbols


# if raspberry pi, install libssl-dev

# python, regex websites to get version????? ???? ??? ???


# Script for installing tmux on systems where you don't have root access.
# tmux will be installed in $HOME/local/bin.
# It's assumed that wget and a C/C++ compiler are installed.

# exit on error
set -e


# Updated VERSIONS 2020.10.25


TMUX_VERSION=3.1b
LIB_VER=2.1.12
NCUR_VER=6.2


# Find out what the latest version of libevent is to download.
wget "https://libevent.org/" -O /tmp/libevent_org.txt
LIB_VER_B=$(grep -Pom 1 "(?<=>libevent-)[\d\.]+(?=-stable\.tar\.gz)" /tmp/libevent_org.txt)


# Find out what the newest version of Tmux is
wget "https://github.com/tmux/tmux/releases" -O /tmp/github_tmux.txt
TMUX_VER_B=$(grep -Pom 1 "(?<=>tmux-)[\d\.]+(?:\w)(?=\.tar\.gz)" /tmp/github_tmux.txt)


# NCurse today has a static release name

echo Static vaules
echo Tmux     : $TMUX_VERSION
echo Libevent : $LIB_VER
echo NCUR_VER : $NCUR_VER
echo ""
echo Detected 
echo Libevent : $LIB_VER_B
echo Tmux     : $TMUX_VER_B

echo DEBUG exit for script development. Eric L.

# exit

# create our directories
mkdir -p $HOME/local $HOME/tmux_tmp
cd $HOME/tmux_tmp



# Tmux source
wget https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
echo Downloaded tmux



# libevent

# get libevent.org web page, set newest version to version found
#wget "https://libevent.org/" -O /tmp/libevent_org.txt
#LIB_VER=$(grep -Pom 1 "(?<=>libevent-)[\d\.]+(?=-stable\.tar\.gz)" /tmp/libevent_org.txt)

wget https://github.com/libevent/libevent/releases/download/release-${LIB_VER}-stable/libevent-${LIB_VER}-stable.tar.gz
echo Downloaded libevent


# NCurses
#wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz
wget ftp://ftp.invisible-island.net/ncurses/ncurses.tar.gz
echo Downloaded ncurse


# extract files, configure, and compile


############
# libevent #
############

tar xvzf libevent-${LIB_VER}-stable.tar.gz
cd libevent-${LIB_VER}-stable
./configure --prefix=$HOME/local --disable-shared
make
make install
cd ..


############
# ncurses  #
############

tar xvzf ncurses.tar.gz
cd ncurses-${NCUR_VER}
./configure --prefix=$HOME/local
make
make install
cd ..


############
#    tmux     #
############

tar xvzf tmux-${TMUX_VERSION}.tar.gz
cd tmux-${TMUX_VERSION}
./configure CFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-L$HOME/local/lib -L$HOME/local/include/ncurses -L$HOME/local/include"
CPPFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-static -L$HOME/local/include -L$HOME/local/include/ncurses -L$HOME/local/lib" make
cp -f tmux $HOME/local/bin
cd ..


# cleanup
rm -rf $HOME/tmux_tmp


echo "$HOME/local/bin/tmux is now available. You can optionally add $HOME/local/bin to your PATH."

