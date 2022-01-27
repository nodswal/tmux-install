#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "You must be root to do this." 1>&2
	sudo $0 $@
   exit 100
fi

# CentOS / RedHat Requirements
# yum install openssl-devel
# build-essentials probably

echo test branch ncurse
# Raspbian Requirements




# Ubuntu 20.04 Requirements
#	apt-get install build-essential -y
#	apt-get install libssl-dev -y



# Arch Requirements
# openssl
