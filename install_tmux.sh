#!/usr/bin/bash
# Master <

	# Last modified: 2022/10/12 9:00:00

	# NO warrenties are implied by this script, use of script at your own RISK.  
	# AKA Read and use VM to test script before using on a system.

	# Author: nodswal, https://github.com/nodswal/tmux-install
	# Even though our paths have crossed, this does not mean we are in the same place in our journey.
	
	# New to this version
		# Detect NCurses Version


# Description:
	# A script for installing the latest stable version of Tmux on system in your home directory so you don't need root access.
	# Install latest version of Tmux, libevent, ncurse as standard user in home directory, or system wide as root.

	# store changes if any made before pull 			= 		# git stash
	# get latest branches data from github 				= 		# git pull
	# switch branch
	# testing git process, some more


#Detect age of script, prompt for git pull?
# git reset --hard # chmod +x ./install_tmux.sh causes change
# git pull
# chmod +x ./install_tmux.sh
# ./install_tmux.sh


# ADD if ~/.tmux.conf exist, name ~/.tmuxNS.conf ?
# prompt if they want it at all
# have basic and nod influenced
cat <<EOF > ~/.tmuxNS.conf

# Set prefix to Ctrl-Space instead of Ctrl-b
unbind C-b
set -g prefix C-Space
bind Space send-prefix

# Split windows using | and -
unbind '"'
unbind %
bind | split-window -h
bind - split-window -v

# Mouse mode
set -g mouse on

bind r source-file ~/.tmux.conf \; display "Config reloaded!"

unbind-key -T copy-mode-vi v

bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi 'C-v' send-keys -X rectangle-toggle
bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"
  
EOF

# look at this .tmux.conf idea's - https://dev.to/iggredible/useful-tmux-configuration-examples-k3g



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

# Enable Debugging
# set -x



################################################
#      Updated VERSION Defaults 2022.01.24     #
################################################

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

# Do I need build tools for each OS?
# Ubuntu :: sudo apt install build-essential

CurOSstr=$(hostnamectl | grep Operating)

echo $CurOS

if   [[ "$CurOSstr" == *"Ubuntu"* ]]; then
	echo "Ubuntu, verifying environment!"
	echo "Verifying libssl-dev"
	sudo apt-get install libssl-dev autotools-dev
	sleep 5
	sudo -k
	# dpkg -s libssl-dev


elif [[ "$CurOSstr" == *"Centos"* ]]; then
	echo "Verifying Centos environment"
	echo "install openssl-devel"
	#rpm -qa | grep openssl-devel


elif [[ "$CurOSstr" == *"Red"* ]]; then
	echo "Verifying Red Hat environment"
	echo "Verifying openssl-devel"
	#rpm -qa | grep openssl-devel


elif [[ "$CurOSstr" == *"Arch"* ]]; then
	echo "Verifying Arch environment"
	echo "Verifying openssl"
	#pacman -Qi openssl


elif [[ "$CurOSstr" == *"Buster"* ]]; then
	echo "Verifying Raspberry Pi Buster environment"
	echo "Verifying libssl-dev"
	# dpkg -s libssl-dev


elif [[ "$CurOSstr" == *"Stretch"* ]]; then
	echo "Verifying Raspberry Pi Stretch environment"
	echo "Verifying libssl-dev"
	# dpkg -s libssl-dev


elif [[ "$CurOSstr" == *"Bullseye"* ]]; then
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
[[ -f ~/mirror_ncurse.txt ]] && rm -rf ~/mirror_ncurse.txt

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
echo    # (optional) move to a new line

sleep 2
rm -rf ~/libevent_org.txt



################################################
# Find out what the newest version of Tmux is  #
################################################

echo "Querying Version on https://github.com/tmux/tmux/releases... Please be patient."
# orig :: wget --no-check-certificate -q "https://github.com/tmux/tmux/releases" -O ~/github_tmux.txt
wget --no-check-certificate -q "https://github.com/tmux/tmux/tags" -O ~/github_tmux.txt

sleep 1

# orig :: TMUX_VER_B=$(grep -Pom 1 "(?<=>tmux-)[\d\.]+(?:\w)(?=\.tar\.gz)" ~/github_tmux.txt)
TMUX_VER_B=$(grep -Pom 1 "[\d\.]+(?:\w)(?=\.tar\.gz)" ~/github_tmux.txt)


echo    # (optional) move to a new line
echo Detected TMUX $TMUX_VER_B on GitHub
echo    # (optional) move to a new line
echo    # (optional) move to a new line

sleep 2
rm -rf ~/github_tmux.txt



################################################
#    NCurse today has a static release name    #
################################################

#  Adding versioning from archives - https://invisible-mirror.net/archives/ncurses/
echo "Querying Version on https://invisible-mirror.net/archives/ncurses/?C=M;O=D... Please be patient."
wget --no-check-certificate -q "https://invisible-mirror.net/archives/ncurses/?C=M;O=D" -O ~/mirror_ncurse.txt
sleep 1

NCUR_VER_B=$(grep -Pom 1 "(?<=>ncurses-)[\d\.]+(?:\w)(?=\.tar\.gz)" ~/mirror_ncurse.txt)


echo    # (optional) move to a new line
echo Detected NCurses $NCUR_VER_B on NCurses Mirror.
echo    # (optional) move to a new line
echo    # (optional) move to a new line

sleep 2
rm -rf ~/mirror_ncurse.txt



################################################
#             Display Versions found           #
################################################

echo "Static script versions."
echo "Tmux     : $TMUX_VERSION"
echo "Libevent : $LIB_VER"
echo "NCUR_VER : $NCUR_VER"

echo    # (optional) move to a new line
echo    # (optional) move to a new line

echo "DETECTED VERSIONS from WEBSITES:"
echo "Newest Tmux Ver    : 		$TMUX_VER_B"
echo "Newest Libevent Ver: 		$LIB_VER_B"
echo "Newest NCURSES Ver : 		$NCUR_VER_B"

sleep 5s

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
	NCUR_VER=$NCUR_VER_B 
fi

echo    # (optional) move to a new line
echo    # (optional) move to a new line
echo    # (optional) move to a new line

echo "Versions to be installed are the following: "
echo "Tmux:     $TMUX_VERSION"
echo "LibEvent: $LIB_VER"
echo "NCurses:  $NCUR_VER"

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
echo    # (optional) move to a new line
echo "Downloading tmux"
echo    # (optional) move to a new line
# Orig :: wget -q https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
wget --output-document=tmux-${TMUX_VERSION}.tar.gz -q https://github.com/tmux/tmux/archive/refs/tags/${TMUX_VERSION}.tar.gz
echo "Downloaded tmux"
echo    # (optional) move to a new line




################################################
#             libevent Download                #
################################################

echo    # (optional) move to a new line
echo    # (optional) move to a new line
echo "Downloading libevent"
echo    # (optional) move to a new line
wget -q https://github.com/libevent/libevent/releases/download/release-${LIB_VER}-stable/libevent-${LIB_VER}-stable.tar.gz
echo "Downloaded libevent"
echo    # (optional) move to a new line



################################################
#             NCurses Download                 #
################################################

echo    # (optional) move to a new line
echo    # (optional) move to a new line
echo "Downloading ncurse"
echo    # (optional) move to a new line
# wget -q ftp://ftp.invisible-island.net/ncurses/ncurses.tar.gz
wget -q https://invisible-mirror.net/archives/ncurses/ncurses-${NCUR_VER}.tar.gz
echo "Downloaded ncurse"
echo    # (optional) move to a new line




################################################
#    Extract files, Configure, and Compile     #
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

tar xvzf ncurses-${NCUR_VER}.tar.gz

cd ncurses*/

# change to cd ncurses*/  ???
# ncursedir=$(find . -maxdepth 1 -type d -name '*ncur*' -print -quit)    
# cd $ncursedir				# since I can't get the version number and can't CD into it based on a captured version

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
	./configure CFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-L$HOME/local/lib -L$HOME/local/include/ncurses -L$HOME/local/include" CPPFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-static -L$HOME/local/include -L$HOME/local/include/ncurses -L$HOME/local/lib" 

	make -j
	
	cp -f tmux $HOME/local/bin/tmux${TMUX_VERSION}
	ln -s $HOME/local/bin/tmux${TMUX_VERSION} $HOME/local/bin/tmux
	# ln -s file link
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

# Tmux autocomplete?
# curl https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/master/completions/tmux > ~/.bash_completion


# add basic config, allow github url to get users config?





	# local user install
		# tmux will be installed in $HOME/local/bin.

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

		# Red Hat 7/8, CentOS 7/8
			# Last Tested:
			# yum install openssl-devel -y


		# Debian, Ubuntu 18.04/20.04 LTS
			# Last Tested:
			# apt-get install libssl-dev -y


		# Arch 
			# Last Tested:
			# pacman -Syu openssl -y


		# Raspberry Pi
			# Last Tested:
			# apt-get install libssl-dev -y


		# Additional OS?
			# tell me how to install it from new installation


# Install in addition? probably not
	# install fonts-powerline
	# install powerline
	#  ** need a font that supports symbols installed on windows, nerd tree infuses hundreds of fonts with symbols


# add a .tmux_ns.conf?



# VirtualBox ( self note - not related to tmux install )
	# Ubuntu additions - sudo apt install build-essential dkms linux-headers-$(uname -r)


#***# code to install local without root was obtained from search on google, when I find where I got that sections from I will created that location.
# I still don't know the exact place



####################################################################################################################################
#                                                           END                                                                    #
####################################################################################################################################
