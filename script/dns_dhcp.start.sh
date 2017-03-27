#!/bin/sh

# USE the trap if you need to also do manual cleanup after the service is stopped,
#     or need to start multiple services in the one container
trap "echo TRAPed signal" HUP INT QUIT TERM

# start service in background here
/usr/bin/rsync --daemon --config=/etc/rsync/rsyncd.conf
#/usr/sbin/dhcpd -d --no-pid
service isc-dhcp-server start
service bind9 start

echo "[hit enter key to exit] or run 'docker stop <container>'"
read

# stop service and clean up here
#echo "stopping apache"
#/usr/sbin/apachectl stop
/usr/bin/rsync stop
service isc-dhcp-server stop
service bind9 stop

echo "exited $0"
