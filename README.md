# Tmux-Install
Installs the Latest or noted versions of Tmux, ncurse, libevent in a users homedirectory ( No root required ) or system based install ( root / sudo required ).  Great for having tmux anywhere you don't have root, school, work (with permission).

Repo's to install tmux are usually way out of date, and I want to enjoy the Tmux goodness sooner (Now plus compile time, I mean NOW, but I'll have to wait).

It does a basic parse using curl to save the webpage local, and then greps for a stable release using regex to capture the version number.  We then download the files, extract them, build...


Primary OS's I have tested with...

  -Ubuntu
    20.04 LTS
    22.04 LTS
  
  -Linux Mint

  -RedHat 7/8
  
  -Centos 7/8

  -raspbian (Buster/Strech)
  
  ...
  
-Requirements
  openssl package which has libssl ( Not required by this script, but required by tmux build process )
  If you need to know the package read the script.
  
# Installation
  git clone https://github.com/nodswal/tmux-install


$ Upgrade script
cd ~/.tmux-install && git pull 
  # && ./install  # Not sure what I will do with a previous version
  # Maybe name tmux3_2a and an alias or symbolic link from tmux
  # When building the next one I can go back.


wget https://raw.githubusercontent.com/nodswal/tmux-install/master/install_tmux.sh

chmod +x ./install_tmux.sh

./install_tux.sh


-run install_tmux.sh as a basic user to install to your local home directory.
  
or
  
-run as root to have the option to install system wide.
  
  
- Todo
