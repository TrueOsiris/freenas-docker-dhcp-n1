#!/bin/sh
#date >> /config/dhcp/dhcp-docker.log
#pgrep dhcpd >>/config/dhcp/dhcp-docker.log
#if [ -f /config/dhcp/dhcpd.pid ]; then
#  if [ `cat /config/dhcp/dhcpd.pid` -eq '' ]; then
#    echo "pid file empty. Starting dhcpd." >>/config/dhcp/dhcp-docker.log
#    exec 1>>/config/dhcp/dhcp-docker.log 2>>/config/dhcp/dhcp-docker.log chpst -u root /usr/sbin/dhcpd \
#     -cf /config/dhcp/dhcpd.conf -tf /config/dhcp/dhcp-startup.log -pf /config/dhcp/dhcpd.pid
#  else 
#    echo cat /config/dhcp/dhcpd.pid : `cat /config/dhcp/dhcpd.pid`
#    echo pgrep dhcpd : `pgrep dhcpd`
#    if [ ! "`cat /config/dhcp/dhcpd.pid`" -eq "`pgrep dhcpd`" ]; then
#      echo "dhcpd not running. Starting." >>/config/dhcp/dhcp-docker.log
#      exec 1>>/config/dhcp/dhcp-docker.log 2>>/config/dhcp/dhcp-docker.log chpst -u root /usr/sbin/dhcpd \
#       -cf /config/dhcp/dhcpd.conf -tf /config/dhcp/dhcp-startup.log -pf /config/dhcp/dhcpd.pid
#    else
#      echo "dhcpd already running. " >>/config/dhcp/dhcp-docker.log
#    fi
#  fi
#else
#  echo "dhcpd not running, pid file doesn't exist" >>/config/dhcp/dhcp-docker.log
#  exec 1>>/config/dhcp/dhcp-docker.log 2>>/config/dhcp/dhcp-docker.log chpst -u root /usr/sbin/dhcpd \
#   -cf /config/dhcp/dhcpd.conf -tf /config/dhcp/dhcp-startup.log -pf /config/dhcp/dhcpd.pid
#fi
exec 1>/dev/null 2>/dev/null chpst -u root /usr/sbin/dhcpd -4 -p 520 -cf /config/dhcp/dhcpd.conf \
  -tf /config/dhcp/dhcp-startup.log -pf /config/dhcp/dhcpd.pid
