#!/bin/sh
exec 1>>/config/dhcp/dhcp-docker.log 2>>/config/dhcp/dhcp-docker.log chpst -u root \
  /usr/sbin/dhcpd -4 -p 67 -cf /config/dhcp/dhcpd.conf -tf /config/dhcp/dhcp-startup.log \
  -pf /config/dhcp/dhcpd.pid -lf /config/dhcp/dhcpd.leases
