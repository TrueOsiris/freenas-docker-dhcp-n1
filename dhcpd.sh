#!/bin/sh

#pgrep dhcpd >>/config/dhcp/dhcp-docker.log
if [ -f /config/dhcp/dhcpd.pid ]; then
        if [ `cat $1` -eq `pgrep dhcpd` ]; then
                echo "dhcpd already running"
        else
                echo "dhcpd not running. Starting." >>/config/dhcp/dhcp-docker.log
                exec 1>>/config/dhcp/dhcp-docker.log 2>>/config/dhcp/dhcp-docker.log chpst -u root /usr/sbin/dhcpd \
                  -cf /config/dhcp/dhcpd.conf -tf /config/dhcp/dhcp-startup.log -pf /config/dhcp/dhcpd.pid
        fi
else
        echo "dhcpd not running, pid file doesn't exist" >>/config/dhcp/dhcp-docker.log
        exec 1>>/config/dhcp/dhcp-docker.log 2>>/config/dhcp/dhcp-docker.log chpst -u root /usr/sbin/dhcpd \
          -cf /config/dhcp/dhcpd.conf -tf /config/dhcp/dhcp-startup.log -pf /config/dhcp/dhcpd.pid
fi
