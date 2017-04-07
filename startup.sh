#!/bin/bash

set -e

if [ -f /config/dhcp.setup.completed ]; then
        echo 'already configured'
else    
        ### run once at container start IF no completion file ###
        
        # create config subfolder
        if [ ! -d /config/dhcp ]; then
           mkdir -p /config/dhcp
        fi
        
        # start sshd with root password "test" if not changed
        if [ ! -f /config/dhcp/ssh.pass ]; then
           echo "root:test" > /config/dhcp/ssh.pass
        fi
        cat /config/dhcp/ssh.pass | chpasswd
        sed -i 's/^PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
        /etc/init.d/ssh start
        
        # set the nameservers in resolv.conf
        if [ ! -f /config/dhcp/resolv.conf ]; then
           echo -e "nameserver 10.10.20.20\nnameserver 10.10.30.30\nsearch chaubet\noptions ndots:0" > /config/dhcp/resolv.conf
        fi   
        \cp -r /config/dhcp/resolv.conf /etc/resolv.conf
        #check if Directories inside of /etc/dhcp are present.

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
        echo -e "Do not remove this file.\nIf you do, root password will be reset to the one in " \
                "the config file ssh.pass.\n/etc/resolv.conf will be reset to the one in the config " \
                "file.\n" > /config/dhcp.setup.completed
        date >> /config/dhcp.setup.completed
fi
