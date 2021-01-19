#!/usr/bin/env bash

# Test if tools are installed?

# In tmux_reqs.sh
# Red Hat, Fedora, CentOS - openssl-devel
# Debian, Ubuntu - libssl-dev
# Arch - openssl


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




############
# exit on error
############
set -e


############
# Updated VERSIONS 2021.01.18
############


TMUX_VERSION=3.1b
LIB_VER=2.1.12
NCUR_VER=6.2





############
# Find out what the latest version of libevent is to download.
############

echo Querying Versions on https://libevent.org... Please be patient.
wget -q "https://libevent.org/" -O ~/libevent_org.txt
sleep 1
LIB_VER_B=$(grep -Pom 1 "(?<=>libevent-)[\d\.]+(?=-stable\.tar\.gz)" ~/libevent_org.txt)
echo ""
echo Detected LibEvent $LIB_VER_B 
echo ""

sleep 2


############
# Find out what the newest version of Tmux is
############

echo Querying Version on https://github.com/tmux/tmux/releases... Please be patient.
wget -q "https://github.com/tmux/tmux/releases" -O ~/github_tmux.txt
sleep 1
TMUX_VER_B=$(grep -Pom 1 "(?<=>tmux-)[\d\.]+(?:\w)(?=\.tar\.gz)" ~/github_tmux.txt)
echo ""
echo Detected TMUX $TMUX_VER_B on GitHub
echo ""

sleep 2

############
# NCurse today has a static release name
############

echo ""
echo "Currently latest NCurses version is downloaded and installed"
echo ""




############
# Display Versions found
############
echo Static vaules              DETECTED VERSIONS from WEBSITES
echo Tmux     : $TMUX_VERSION   New Tmux Ver    : $TMUX_VER_B
echo Libevent : $LIB_VER        New Libevent Ver: $LIB_VER_B
echo NCUR_VER : $NCUR_VER       NCURSE		: NO Detection available 
echo ""
echo ""


sleep 2s

read -p "Use Updated version's yY? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	TMUX_VERSION=$TMUX_VER_B 
	LIB_VER=$LIB_VER_B 
fi

echo ""
echo Versions changed to the following
echo Tmux: $TMUX_VERSION
echo LibEvent: $LIB_VER



# echo DEBUG exit for script development. Eric L.

sleep 5
############

# exit

############





############
# create our directories local and tmux_tmp Build directory
############
mkdir -p $HOME/local $HOME/tmux_tmp
cd $HOME/tmux_tmp




############
# Tmux source Download
############
wget -q https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
echo Downloaded tmux




############
# libevent Download
############

# get libevent.org web page, set newest version to version found
#wget "https://libevent.org/" -O /tmp/libevent_org.txt
#LIB_VER=$(grep -Pom 1 "(?<=>libevent-)[\d\.]+(?=-stable\.tar\.gz)" /tmp/libevent_org.txt)

echo Downloading libevent
wget -q https://github.com/libevent/libevent/releases/download/release-${LIB_VER}-stable/libevent-${LIB_VER}-stable.tar.gz
echo Downloaded libevent







############
# NCurses Download
############
#wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz

echo Downloading ncurse
wget -q ftp://ftp.invisible-island.net/ncurses/ncurses.tar.gz
echo Downloaded ncurse






############
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
#   tmux   #
############

tar xvzf tmux-${TMUX_VERSION}.tar.gz
cd tmux-${TMUX_VERSION}
./configure CFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-L$HOME/local/lib -L$HOME/local/include/ncurses -L$HOME/local/include"
CPPFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-static -L$HOME/local/include -L$HOME/local/include/ncurses -L$HOME/local/lib" make
cp -f tmux $HOME/local/bin
cd ..




############
# cleanup
############
rm -rf $HOME/tmux_tmp


echo ""
echo ""
echo ""

echo "$HOME/local/bin/tmux is now available. You can optionally add $HOME/local/bin to your PATH."
