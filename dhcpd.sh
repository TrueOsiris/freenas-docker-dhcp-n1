#!/bin/sh
exec 2>&1 chpst -u root /usr/sbin/dhcpd -cf /config/dhcp/dhcpd.conf
