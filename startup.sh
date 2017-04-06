#!/bin/bash

set -e

echo -e "nameserver 10.10.20.20\nnameserver 10.10.30.30\nsearch chaubet\noptions ndots:0" > /etc/resolv.conf

if [ -f /config/dhcp_setup_do_not_remove.txt ]; then
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
        if [ ! -f /config/dhcp/dhcp-docker.log ]; then
            #touch /config/dhcp/dhcp-docker.log
            date > /config/dhcp/dhcp-docker.log
        fi
        if [ ! -f /config/dhcp/dhcp-startup.log ]; then
            #touch /config/dhcp/dhcp-startup.log
            date > /config/dhcp/dhcp-startup.log
        fi        
        if [ ! -f /config/dhcp/dhcpd.leases ]; then
            touch /config/dhcp/dhcpd.leases
        fi        
        #killall dhcpd
        #sleep 5s
        chmod -R 775 /config/dhcp
        update-locale
        echo "do not remove this file." > /config/dhcp_setup_do_not_remove.txt
        date >> /config/dhcp_setup_do_not_remove.txt
fi
