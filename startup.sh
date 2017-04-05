#!/bin/bash

set -e

if [ -f /config/containter_created.txt ]; then
        echo 'already configured'
else      
        #check if Directories inside of /etc/dhcp are present.
        if [ ! -d /config/dhcp ]; then
           mkdir -p /config/dhcp
        fi
        if [ ! -f /config/dhcp/dhcpd.conf ]; then
            cp /tmp/dhcpd.conf /config/dhcp/dhcpd.conf
        fi
        if [ ! -f /config/dhcp/dhcpd.conf.synced ]; then
            cp /tmp/dhcpd.conf.synced /config/dhcp/dhcpd.conf.synced
        fi
        chmod -R 775 /config/dhcp
        update-locale
        date > /config/container_created.txt
fi
