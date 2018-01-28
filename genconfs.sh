#!/bin/sh

# Copyright (c) 2017-2018 Tokumei authors.
# This software package is licensed for use under the ISC license.
# LICENSE for details.
#
# Tokumei is a simple, self-hosted microblogging platform.
# This script reads your config.json file and generates configuration files
# for Tor and Nginx so that you can run Tokumei an as internet facing service.

# functions

fmt_json() {
    ret="$(tr -d '[:space:]' <<< "$1")"
    ret="$(sed 's/\s+//g;s/"//g;s/,//g' <<< "$ret")"
    ret="$(sed 's/^.*://g' <<< "$ret")"
    echo "$ret"
}

# consts
cfg='cfg/config.json'
torrc_tpl='cfg/.torrc'
clearnet_tpl='cfg/.clearnet'
onion_tpl='cfg/.onion'
torrc_out='cfg/torrc'
clearnetconf='cfg/tokumei-clearnet.conf'
onionconf='cfg/tokumei-onion.conf'


echo 'This script will generate nginx configurations and a torrc.'
echo 'You will need to install these files to run Tokumei as an internet facing service.'
read -p 'Proceed? [Y/n] ' yn
case $yn in
    [Nn]* ) exit
        ;;
esac

echo "Reading config at $cfg."
if [ ! -f "$cfg" ]; then
    echo "Error. File $cfg not found."
    read -p 'Get from latest Tokumei distribution? [Y/n] ' yn
    case $yn in 
        [Nn]* )
            echo "Nothing to do."
            exit
            ;;
        * )
            wget -O "$dist/$cfg" "$cfg"
            echo "Please edit the $cfg$ file, then rerun this script."
            exit
            ;;
    esac
fi

host="$(fmt_json "`grep -e 'Host' "$cfg"`")"
port="$(fmt_json "`grep -e 'Port' "$cfg"`")"

read -p 'Generate tor configurations? [Y/n] ' yn
case $yn in
    [Nn]* )
        cp "$clearnet_tpl" "$clearnetconf"
        sed -i "s/%TOKUMEI/$host/g;s/%PORT/$port/g" "$clearnetconf"
        echo "Check Nginx configuration file at $clearnetconf and copy to /etc/nginx/sites-available/$host"
        echo "$clearnetconf is set up to run Tokumei at $host:$port"
        exit
        ;;
esac

which tor
if [ $? -eq 1 ]; then
    echo "tor binary not available."
    exit
fi

if [ ! -f /var/lib/tor/hidden_service/hostname ]; then
    read -p "Didn't find onion hostname. Generate one? [y/N] " yn
    case $yn in
        [Yy]* )
            while [ ! -f /var/lib/tor/hidden_service/hostname ]; do
                sleep 1
            done
            ;;
        * )
            echo "Abort."
            exit
            ;;
    esac
            
fi


service tor restart
while [ ! -f /var/lib/tor/hidden_service/hostname ]; do
    sleep 1
done
domain=$(cat /var/lib/tor/hidden_service/hostname)

