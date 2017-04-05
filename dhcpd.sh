#!/bin/sh
pgrep dhcpd >>/config/dhcp/dhcp-docker.log
exec 1>>/config/dhcp/dhcp-docker.log 2>>/config/dhcp/dhcp-docker.log chpst -u root /usr/sbin/dhcpd \
     -cf /config/dhcp/dhcpd.conf -tf /config/dhcp/dhcp-startup.log -pf /config/dhcp/dhcpd.pid
