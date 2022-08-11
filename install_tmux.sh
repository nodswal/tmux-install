#!/usr/bin/bash

	# Last modified: 2022/08/10 06:46:49
	
	# NO warrenties are implied by this script, use of script at your own RISK.  
	# AKA Read and use VM to test script before installing on system.

	# Project #SaveTheGirl

	# Author: nodswal, https://github.com/nodswal/tmux-install
	# Even though our paths have crossed, does not mean we are in the same place in our journey's.

# Description:
	# A script for installing the latest stable version of Tmux on system in your home directory so you don't need root access.
	# Install latest version of Tmux, libevent, ncurse as root.

	
# New to this version
	# make -j
	# Root Installation for  system install
		# NOTE: IF running as root, install pre-requirements???


# Notes/idea's at bottom of script

# Settings file, use settings, auto check for updates?



########################
#     Clear Screen     #
########################

printf '\033c'    # Clear screen



########################
#     exit on error    #
########################

set -e



########################
#      Debug MODE      #
########################

# echo $? after exit to see the error code it exited for which ever command

# set -x



################################################
#      Updated VERSION Defaults 2022.01.24     #
################################################

# Create file to have settings for these

TMUX_VERSION=3.1b
LIB_VER=2.1.12
NCUR_VER=6.2





################################################
#  Root User Detection - Install System Wide?  #
################################################

if [ "$EUID" -eq 0 ]
	then read -p "Running script as root, install system wide? [yY] " -n 1 -r
	echo

	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		echo "Installing System Wide!"
		SysWide="yes"
		sleep 5
	fi

fi



################################################
#     OS Make and Model to make descisions     #
################################################

CurOSstr=$(hostnamectl | grep Operating)

echo $CurOSstr

if   [[ "$CurOSstr" == *Ubuntu* ]]; then
	echo "Ubuntu, verifying environment!"
	echo "Verifying libssl-dev"
	sleep 10
	# dpkg -s libssl-dev


elif [[ "$CurOSstr" == *Centos* ]]; then
	echo "Verifying Centos environment"
	echo "install openssl-devel"
	#rpm -qa | grep openssl-devel


elif [[ "$CurOSstr" == *Red* ]]; then
	echo "Verifying Red Hat environment"
	echo "Verifying openssl-devel"
	#rpm -qa | grep openssl-devel


elif [[ "$CurOSstr" == *Arch* ]]; then
	echo "Verifying Arch environment"
	echo "Verifying openssl"
	#pacman -Qi openssl


elif [[ "$CurOSstr" == *Buster* ]]; then
	echo "Verifying Raspberry Pi Buster environment"
	echo "Verifying libssl-dev"
	# dpkg -s libssl-dev


elif [[ "$CurOSstr" == *Stretch* ]]; then
	echo "Verifying Raspberry Pi Stretch environment"
	echo "Verifying libssl-dev"
	# dpkg -s libssl-dev


elif [[ "$CurOSstr" == *Bullseye* ]]; then
	echo "Verifying Raspberry Pi BullsEye environment"
	echo "Verifying libssl-dev"
	# dpkg -s libssl-dev


else
	echo "Unknown OS, continue trying to install?"
	echo "Menu? Develope this area!"


fi



########################################################################
#      Clean UP in case issue last time                                #
########################################################################

[[ -f ~/libevent_org.txt ]] && rm -rf ~/libevent_org.txt
[[ -f ~/github_tmux.txt ]] && rm -rf ~/github_tmux.txt
[ -d "$HOME/tmux_tmp" ] && rm -rf $HOME/tmux_tmp



########################################################################
# Find out what the latest version of libevent is to download.         #
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
# Find out what the newest version of Tmux is  #
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
#    NCurse today has a static release name    #
################################################

#  Adding versioning from archives - https://invisible-mirror.net/archives/ncurses/

echo    # (optional) move to a new line
echo "Currently the latest version of NCurses will be installed!"
echo    # (optional) move to a new line



################################################
#             Display Versions found           #
################################################

echo "Static vaules"
echo "Tmux     : $TMUX_VERSION"
echo "Libevent : $LIB_VER"
echo "NCUR_VER : $NCUR_VER"

echo    # (optional) move to a new line
echo    # (optional) move to a new line

echo "DETECTED VERSIONS from WEBSITES"
echo "New Tmux Ver    : $TMUX_VER_B"
echo "New Libevent Ver: $LIB_VER_B"
echo "NCURSE		: Unable to Detect Versions of NCurse by design"

sleep 9s

echo    # (optional) move to a new line
echo    # (optional) move to a new line



################################################
#         Prompt to use new version            #
################################################

read -p "Use Updated version's from WEBSITE [yY]? " -n 1 -r
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
echo "LibEvent: Latest"

echo    # (optional) move to a new line
echo    # (optional) move to a new line

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

echo    # (optional) move to a new line
echo "Downloading tmux"
wget -q https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
echo "Downloaded tmux"
echo    # (optional) move to a new line



################################################
#             libevent Download                #
################################################

echo    # (optional) move to a new line
echo "Downloading libevent"
wget -q https://github.com/libevent/libevent/releases/download/release-${LIB_VER}-stable/libevent-${LIB_VER}-stable.tar.gz
echo "Downloaded libevent"
echo    # (optional) move to a new line



################################################
#             NCurses Download                 #
################################################

echo    # (optional) move to a new line
echo "Downloading ncurse"
wget -q ftp://ftp.invisible-island.net/ncurses/ncurses.tar.gz
echo "Downloaded ncurse"
echo    # (optional) move to a new line



################################################
#                                           #  #
################################################
#    Extract files, Configure, and Compi    #  #
################################################
#                                           #  #
################################################

sleep 5



################################################
#           Libevent  Extraction               #
################################################

tar xvzf libevent-${LIB_VER}-stable.tar.gz
cd libevent-${LIB_VER}-stable

if [[ $SysWide == "yes" ]]; then
	./configure --disable-shared
else
	./configure --prefix=$HOME/local --disable-shared
fi

make -j
make install
cd ..



####################################
#        Ncurses  Extraction       #
####################################

tar xvzf ncurses.tar.gz

# change to cd ncurses*/  ???
ncursedir=$(find . -maxdepth 1 -type d -name '*ncur*' -print -quit)    
cd $ncursedir				# since I can't get the version number and can't CD into it based on a captured version

if [[ $SysWide == "yes" ]]; then
	./configure
else
	./configure --prefix=$HOME/local
fi

make -j
make install
cd ..



###################################
#         Tmux  Extraction        #
###################################

tar xvzf tmux-${TMUX_VERSION}.tar.gz
cd tmux-${TMUX_VERSION}

if [[ $SysWide == "yes" ]]; then
	./configure
	make -j
	make install
else
	./configure CFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-L$HOME/local/lib -L$HOME/local/include/ncurses -L$HOME/local/include"
CPPFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-static -L$HOME/local/include -L$HOME/local/include/ncurses -L$HOME/local/lib" make -j
	cp -f tmux $HOME/local/bin
fi

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

printf '\033c'    # Clear screen
echo    # (optional) move to a new line

if [[ $SysWide == "yes" ]]; then
	echo "Installed System Wide."
else
	echo "$HOME/local/bin/tmux is now available. You can optionally add $HOME/local/bin to your PATH."
fi

exit $?


####################################################################################################################################
#                                                           Extra's?                                                                #
####################################################################################################################################

# Tmux autocomplete? github?

# add basic config, allow github url to get users config?


# local user install
		# tmux will be installed in $HOME/local/bin.
		# PROMPT for location?
			# TEST if you have permission?

	# It's assumed that wget and a C/C++ compiler are installed.
		# Fix so prompted whatever is missing



# Add!
	# a Test if requirements are installed?
	# install as root option?
	# wget/curl url not valid
	# if fzf and smenu are installed use them?
	# store versions if not the same as in file?


	# check what OS?
		# look if requirements are installed


# From Version Control, not stable, just most rescent repo compile
	# git clone https://github.com/tmux/tmux.git
	# cd tmux
	# sh autogen.sh
	# ./configure
	# make && sudo make install


# Prefer requirements to be installed from same script. ***hostnamectl | grep operating*** system, contains ubuntu, contains red hat, contains centos?

		# Red Hat 7/8/9, Rocky 8/9, CentOS 7
			# Last Tested:
			# yum install openssl-devel -y


		# Debian, Ubuntu 18.04 LTS
		#				 20.04 LTS
		#				 22.04 LTS
			# Last Tested:
			# apt-get install libssl-dev -y


		# Arch - 
			# Last Tested:
			# pacman -Syu openssl -y


		# Raspberry Pi - Stretch/jessie/...
			# Last Tested:
			# apt-get install libssl-dev -y


		# Additional OS?
			# tell me how to install it from new installation


# Install in addition? probably not, maybe options for?
	# install fonts-powerline
	# install powerline
	#  ** need a font that supports symbols installed on windows, nerd tree infuses hundreds of fonts with symbols


# add a .tmux_nod.conf?

# have script periodicly check for tmux updates on github?


# VirtualBox ( self note - not related to tmux install )
	# Ubuntu additions - sudo apt install build-essential dkms linux-headers-$(uname -r)


#***# code to install local without root was obtained from search on google, when I find where I got that sections from I will created that location.
# I still don't know the exact place




####################################################################################################################################
#                                                           END                                                                    #
####################################################################################################################################