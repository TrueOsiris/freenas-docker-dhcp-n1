#!/bin/sh
exec 1>/dev/null 2>/dev/null chpst -u root /usr/sbin/dhcpd -4 -cf /config/dhcp/dhcpd.conf \
  -tf /config/dhcp/dhcp-startup.log -pf /config/dhcp/dhcpd.pid -lf /config/dhcp/dhcpd.leases
