#!/usr/bin/env bash

	# Last modified: 2022/01/11 09:48:13

	# Author: nodswal, d.e.laws@gmail.com

# A script for installing the latest stable version of Tmux on systems where you don't have root access.
	# tmux will be installed in $HOME/local/bin.
	# It's assumed that wget and a C/C++ compiler are installed.


# add
	# a Test if tools are installed?s 


# In tmux_reqs.sh
	# Red Hat, Fedora, CentOS - openssl-devel
	# Debian, Ubuntu - libssl-dev
	# Arch - openssl
	# if raspberry pi, install libssl-dev

# Install in addition?
	# install fonts-powerline
	# install powerline

	#  ** need a font that supports symbols installed on windows, nerd tree infuses hundreds of fonts with symbols


# python, regex websites to get version????? ???? ??? ???




########################
#     exit on error
########################

set -e



########################
#      Debug MODE
########################

# echo $? after exit to see the error code it exited for which ever command
# set -x




################################################
#      Updated VERSION Defaults 2021.08.25
################################################

TMUX_VERSION=3.1b
LIB_VER=2.1.12
NCUR_VER=6.2





########################################################################
#      Clean UP in case issue last time
########################################################################

[[ -f ~/libevent_org.txt ]] && rm -rf ~/libevent_org.txt
[[ -f ~/github_tmux.txt ]] && rm -rf ~/github_tmux.txt
[ -d "$HOME/tmux_tmp" ] && rm -rf $HOME/tmux_tmp




########################################################################
# Find out what the latest version of libevent is to download.
########################################################################

echo Querying Versions on https://libevent.org... Please be patient.
wget --no-check-certificate -q "https://libevent.org/" -O ~/libevent_org.txt
sleep 1

LIB_VER_B=$(grep -Pom 1 "(?<=>libevent-)[\d\.]+(?=-stable\.tar\.gz)" ~/libevent_org.txt)

echo    # (optional) move to a new line
echo "Detected LibEvent $LIB_VER_B"
echo    # (optional) move to a new line

sleep 2
rm -rf ~/libevent_org.txt




################################################
# Find out what the newest version of Tmux is
################################################

echo "Querying Version on https://github.com/tmux/tmux/releases... Please be patient."
wget --no-check-certificate -q "https://github.com/tmux/tmux/releases" -O ~/github_tmux.txt
sleep 1

TMUX_VER_B=$(grep -Pom 1 "(?<=>tmux-)[\d\.]+(?:\w)(?=\.tar\.gz)" ~/github_tmux.txt)

echo    # (optional) move to a new line
echo Detected TMUX $TMUX_VER_B on GitHub
echo    # (optional) move to a new line

sleep 2
rm -rf ~/github_tmux.txt




################################################
# NCurse today has a static release name
################################################

echo    # (optional) move to a new line
echo "Currently the latest version of NCurses will be installed!"
echo    # (optional) move to a new line




################################################
#             Display Versions found           #
################################################

echo "Static vaules                    DETECTED VERSIONS from WEBSITES"
echo "Tmux     : $TMUX_VERSION         New Tmux Ver    : $TMUX_VER_B"
echo "Libevent : $LIB_VER              New Libevent Ver: $LIB_VER_B"
echo "NCUR_VER : $NCUR_VER             NCURSE		: Unable to Detect Versions"
echo    # (optional) move to a new line
echo    # (optional) move to a new line

sleep 2s




################################################
#         Prompt to use new version            #
################################################

read -p "Use Updated version's yY? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	TMUX_VERSION=$TMUX_VER_B 
	LIB_VER=$LIB_VER_B 
fi



echo    # (optional) move to a new line
echo    # (optional) move to a new line
echo    # (optional) move to a new line

echo "Versions to be installed are the following: "
echo "Tmux: $TMUX_VERSION"
echo "LibEvent: $LIB_VER"

sleep 5




################################################################
#        Create the directories for the                        #
#               ~/local and                                    #
#               ~/tmux_tmp Build directory                     #
################################################################

mkdir -p $HOME/local $HOME/tmux_tmp
cd $HOME/tmux_tmp




################################################
#             Tmux source Download             #
################################################

echo "Downloading tmux"
wget -q https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
echo "Downloaded tmux"




################################################
#             libevent Download                #
################################################

# get libevent.org web page, set newest version to version found
#wget "https://libevent.org/" -O /tmp/libevent_org.txt
#LIB_VER=$(grep -Pom 1 "(?<=>libevent-)[\d\.]+(?=-stable\.tar\.gz)" /tmp/libevent_org.txt)

echo "Downloading libevent"
wget -q https://github.com/libevent/libevent/releases/download/release-${LIB_VER}-stable/libevent-${LIB_VER}-stable.tar.gz
echo "Downloaded libevent"




################################################
#             NCurses Download                 #
################################################

echo "Downloading ncurse"
wget -q ftp://ftp.invisible-island.net/ncurses/ncurses.tar.gz
echo "Downloaded ncurse"




    ################################################
    #                                            #
################################################
#    Extract files, Configure, and Compile     #
################################################
    #                                            #
    ################################################




################################################
#           Libevent  Extraction               #
################################################

tar xvzf libevent-${LIB_VER}-stable.tar.gz
cd libevent-${LIB_VER}-stable

./configure --prefix=$HOME/local --disable-shared
make
make install
cd ..




####################################
#        Ncurses  Extraction       #
####################################

tar xvzf ncurses.tar.gz
ncursedir=$(find . -maxdepth 1 -type d -name '*ncur*' -print -quit)
	#cd ncurses-${NCUR_VER}  #Original 
cd $ncursedir				# since I can't get the version number and can't CD into it based on a captured version

./configure --prefix=$HOME/local
make
make install
cd ..




###################################
#         Tmux  Extraction        #
###################################

tar xvzf tmux-${TMUX_VERSION}.tar.gz
cd tmux-${TMUX_VERSION}

./configure CFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-L$HOME/local/lib -L$HOME/local/include/ncurses -L$HOME/local/include"
CPPFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-static -L$HOME/local/include -L$HOME/local/include/ncurses -L$HOME/local/lib" make
cp -f tmux $HOME/local/bin
cd ..




############################
#     cleanup Section      #
############################

rm -rf $HOME/tmux_tmp

echo    # (optional) move to a new line
echo    # (optional) move to a new line
echo    # (optional) move to a new line
echo    # (optional) move to a new line
echo    # (optional) move to a new line
echo    # (optional) move to a new line

echo "$HOME/local/bin/tmux is now available. You can optionally add $HOME/local/bin to your PATH."

exit $?




####################################################################################################################################
#                                                           END                                                                    #
####################################################################################################################################
