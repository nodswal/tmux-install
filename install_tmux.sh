#!/usr/bin/bash
# * Branch: MakeChangesHere <

# Last modified: 2023/03/22 07:36:58

# * NO warrenties are implied by this script, use of script is at your own RISK.
	# AKA Read and use VM to test script before using it on a system.

# * Author: NodSwal, https://github.com/nodswal/tmux-install
	# Even though our paths have crossed, that does not mean we are in the same place in our journies.


# * Description:
	# A script for installing the latest stable version of Tmux on system in your home directory so you don't need root access.
	# Install latest version of Tmux, libevent, ncurse as standard user in home directory, or system wide as root.


# * New to this version
	# 

# * Variables
inTesting="y"


# ? MY git Notes
	# store changes if any made before pull 			= 		# git stash
	# get latest branches data from github 				= 		# git pull
	# switch branch
	# testing git process, some more


# * Detect age of script, prompt for git pull?
# git reset --hard # chmod +x ./install_tmux.sh causes change
# git pull
# chmod +x ./install_tmux.sh
# ./install_tmux.sh


# * ADD if ~/.tmux.conf exist, name ~/.tmux-NS.conf ?
	# * Maybe add to a non root directory ( ~/ )
	# have basic and Nod influenced .tmux scripts


###############################
# *   Install this script   * #
###############################
	# https://github.com/nodswal/tmux-install/blob/master/install_tmux.sh
	# wget https://github.com/nodswal/tmux-install/blob/eda565e7c4ae73ab7ed08de48fd7945af150b3b9/install_tmux.sh
	# git clone or git download script
	# chmod +x ./tmux-install.sh
	# ./tmux-install.sh or sudo ./tmux-install.sh

	# TODO: Detect if there is a newer version?


###############################
# TODO *   My VS Code Plugins    * #
###############################

# Prettier


###############################

# * better visibility
# ! deprecated method, do not use || warning
# ? should this method be exposed in the public api
# TODO: refactor this moethod
# @param myParam
#


# Todo: Basic install or menu based install
# * whiptail checkbox menu selection?
# ? Put in test mode

# TODO: install plugins, probably near the end
# Todo: ~/.tmux/plugins/tpm/bin/install_plugins

# * Create .tmux-NS.conf
cat <<EOF > ~/.tmux-NS.conf

# * NodSwal install-tmux config
# * https://github.com/nodswal/tmux-install

# * Config for version 3.0+


# * Set prefix to Control-A ::AND:: Ctrl-Space instead of Ctrl-b
unbind C-b
set -g prefix C-a
set -g prefix2 C-Space
bind Space send-prefix


# * Split windows using | and - instead of " and %, maybe use these for full screen splits
unbind '"'
unbind %
bind | split-window -h
bind - split-window -v


# * Reload tmux with prefix + r
bind r source-file ~/.tmux.conf \; display "Config reloaded!"


# * Mouse mode
set -g mouse on

# * These bindings are for X Windows only. If you're using a different
# * window system you have to replace the `xsel` commands with something
# * else. See https://github.com/tmux/tmux/wiki/Clipboard#available-tools

bind -T copy-mode    DoubleClick1Pane select-pane \; send -X select-word \; send -X copy-pipe-no-clear "xsel -i"
bind -T copy-mode-vi DoubleClick1Pane select-pane \; send -X select-word \; send -X copy-pipe-no-clear "xsel -i"
bind -n DoubleClick1Pane select-pane \; copy-mode -M \; send -X select-word \; send -X copy-pipe-no-clear "xsel -i"
bind -T copy-mode    TripleClick1Pane select-pane \; send -X select-line \; send -X copy-pipe-no-clear "xsel -i"
bind -T copy-mode-vi TripleClick1Pane select-pane \; send -X select-line \; send -X copy-pipe-no-clear "xsel -i"
bind -n TripleClick1Pane select-pane \; copy-mode -M \; send -X select-line \; send -X copy-pipe-no-clear "xsel -i"
bind -n MouseDown2Pane run "tmux set-buffer -b primary_selection \"$(xsel -o)\"; tmux paste-buffer -b primary_selection; tmux delete-buffer -b primary_selection"



set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'laktak/extrakto'   # prefix + TAB
set -g @plugin 'jimeh/tmux-themepack'
	set -g @themepack 'powerline/block/blue'
set -g @plugin 'sainnhe/tmux-fzf'

set -g @yank_action 'copy-pipe-no-clear'
bind -T copy-mode    C-c send -X copy-pipe-no-clear "xsel -i --clipboard"
bind -T copy-mode-vi C-c send -X copy-pipe-no-clear "xsel -i --clipboard"



# * Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'



# * plugins ?
# * 	* fzf

# * use ctrl + space is prefix?
# unbind C-Space
# set -g prefix C-Space
# bind C-Space send-prefix


EOF


# * this will fail if the file already exist
ln -s ~/.tmux-NS.conf ~/.tmux.conf



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
# *     Updated VERSION Defaults 2023.01.12     #
################################################

# left as older versions for testing the parse for new versions

TMUX_VERSION=3.1a
LIB_VER=2.1.12
NCUR_VER=6.2



################################################
# * Root User Detection - Install System Wide?  #
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
# TODO    OS Make and Model to make descisions     #
################################################

# Do I need build tools for each OS?
# Ubuntu :: sudo apt install build-essential

# xclip ?
# libssl-dev ?

# base install, update, and test script, what does it need to install



CurOSstr=$(hostnamectl | grep Operating)

echo $CurOSstr
echo ""

sleep 10s

if   [[ "$CurOSstr" == *"Ubuntu"* ]]; then
	echo "Ubuntu, verifying environment!  If this passes no need to sudo install apps"
	echo
	echo "Verifying libssl-dev"

	# Todo: check to see if package is installed before sudo, for loop?

	sudo apt-get install libssl-dev autotools-dev automake pkg-config bison autoconf libtool pkg-config cmake -y

	echo "Installing Extra's: xclip, xsel, git"
	sudo apt-get install xclip xsel git -y

	if [ "$inTesting" == "y" ]; then
		sudo apt-get install openssh-server -y
	else
		echo not testing, not installing openssh-server
	fi


	sleep 5
	sudo -k
	# dpkg -s libssl-dev


elif [[ "$CurOSstr" == *"Centos"* ]]; then
	echo "Verifying Centos environment"
	echo "install openssl-devel"
	#rpm -qa | grep openssl-devel


elif [[ "$CurOSstr" == *"Red Hat Enterprise Linux"* ]]; then
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

sleep 10s


########################################################################
#                  Install TPM (Tmux plugin Manager)                   #
########################################################################

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm



########################################################################
#                  Clean UP in case issue last run                     #
########################################################################

[[ -f ~/libevent_org.txt ]] && rm -rf ~/libevent_org.txt
[[ -f ~/github_tmux.txt ]] && rm -rf ~/github_tmux.txt
[[ -f ~/mirror_ncurse.txt ]] && rm -rf ~/mirror_ncurse.txt

[ -d "$HOME/tmux_tmp" ] && rm -rf $HOME/tmux_tmp && echo "Clean up $HOME/tmux_tmp" && sleep 15



########################################################################
# *   Find out what the latest version of libevent is to download.     #
########################################################################

echo Querying Versions on https://libevent.org... Please be patient.
wget --no-check-certificate -q "https://libevent.org/" -O ~/libevent_org.txt
sleep 3

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
wget --no-check-certificate -q "https://github.com/tmux/tmux/tags" -O ~/github_tmux.txt

sleep 3

# orig :: TMUX_VER_B=$(grep -Pom 1 "(?<=>tmux-)[\d\.]+(?:\w)(?=\.tar\.gz)" ~/github_tmux.txt)
TMUX_VER_B=$(grep -Pom 1 "[\d\.]+(?:\w)(?=\.tar\.gz)" ~/github_tmux.txt)


echo    # (optional) move to a new line
echo Detected TMUX $TMUX_VER_B on GitHub
echo    # (optional) move to a new line
echo    # (optional) move to a new line

sleep 2
rm -rf ~/github_tmux.txt



################################################
#  Find out what the newest version of NCurse  #
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
# *           Display Versions found           #
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

sleep 6s

echo    # (optional) move to a new line
echo    # (optional) move to a new line



################################################
# *       Prompt to use new version            #
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

# TODO prompt for installation directory if not root?
	# user may not want it in ~/local

mkdir -p $HOME/local/tmux${TMUX_VERSION} $HOME/local/bin $HOME/tmux_tmp
cd $HOME/tmux_tmp



################################################
#             Tmux source Download             #
################################################

echo    # (optional) move to a new line
echo    # (optional) move to a new line
echo "Downloading tmux"
echo    # (optional) move to a new line

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
	./configure --prefix=$HOME/local/tmux${TMUX_VERSION} --disable-shared
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
	./configure --prefix=$HOME/local/tmux${TMUX_VERSION}
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
	sh ./autogen.sh
	./configure
	make -j
	make install
else
	sh ./autogen.sh
	./configure CFLAGS="-I$HOME/local/tmux${TMUX_VERSION}/include -I$HOME/local/tmux${TMUX_VERSION}/include/ncurses" LDFLAGS="-L$HOME/local/tmux${TMUX_VERSION}/lib -L$HOME/local/tmux${TMUX_VERSION}/include/ncurses -L$HOME/local/tmux${TMUX_VERSION}/include" CPPFLAGS="-I$HOME/local/tmux${TMUX_VERSION}/include -I$HOME/local/tmux${TMUX_VERSION}/include/ncurses" LDFLAGS="-static -L$HOME/local/tmux${TMUX_VERSION}/include -L$HOME/local/tmux${TMUX_VERSION}/include/ncurses -L$HOME/local/tmux${TMUX_VERSION}/lib" 

	make -j

# TODO make directory ~/local/tmux${TMUX_VERSION}/bin/tmux${TMUX_VERSION}
	# cp -f tmux $HOME/local/bin/tmux${TMUX_VERSION}
	  cp -f tmux $HOME/local/tmux${TMUX_VERSION}/bin/tmux${TMUX_VERSION}
		ln -s $HOME/local/tmux${TMUX_VERSION}/bin/tmux${TMUX_VERSION} $HOME/local/bin/tmux
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

sleep 3s

printf '\033c'    # Clear screen
echo    # (optional) move to a new line

if [[ $SysWide == "yes" ]]; then
	echo "Installed System Wide."
else
	echo "$HOME/local/bin/tmux is now available. You can optionally add $HOME/local/bin to your PATH."
	echo "export PATH=\$PATH:\$HOME/local/bin # Install_Tmux.sh" >> ~/.bashrc
fi

# TODO echo $_ or  $0


# TODO need to source .bashrc so it knows where tmux is installed to update tmux plugins

source ~/.bashrc

echo "Install tmux plugins"
~/.tmux/plugins/tpm/bin/install_plugins
echo $?

echo "Git fzf, install fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo "tmux, prefix, shift + I to install any other plugins"














####################################################################################################################################
#                                                           Extra's?                                                                #
####################################################################################################################################


# TODO: Error handling
	# if the file isn't download ( tmux-3.1a.tar.gz doesn't exist after wget of file )
	# if it can't parse the page for latest version
	# if error extracting
	# * disk space check

#
# TODO name tmux executable tmux$version and symlink it?
	# example tmux3_3a

	# ln -s exisiting file           symbolic link named file
	# ln -s $HOME/local/bin/tmux3_3a $HOME/local/bin/tmux

# * make a my_plugins file, so user can store that and have that installed as well ?

# * Create answer file
	# predefined script options?
		# if .tmux-NodSwal is created
		#



# * prompt to install the following or any additions ?
	# Tmux autocomplete?
		# curl https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/master/completions/tmux > ~/.bash_completion
	# Tmux plugin manager
	# plugins
	# fzf
	# xclip
	# 


# *add basic config, allow github url to get users config?


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

#
# TODO: Check what OS? look if requirements are installed

# * Install Tmux from their github repo, From Version Control, not stable, just most rescent repo compile
	# git clone https://github.com/tmux/tmux.git
	# cd tmux
	# sh autogen.sh
	# ./configure
	# make && sudo make install

#
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

#
# Install in addition? probably not
	# install fonts-powerline
	# install powerline
	#  ** need a font that supports symbols installed on windows, nerd tree infuses hundreds of fonts with symbols


#
# VirtualBox ( self note - not related to tmux install )
	# Ubuntu additions - sudo apt install build-essential dkms linux-headers-$(uname -r)





####################################################################################################################################
#                                                           END                                                                    #
####################################################################################################################################
####################################################################################################################################

