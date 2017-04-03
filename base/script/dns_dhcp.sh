#!/bin/sh

# USE the trap if you need to also do manual cleanup after the service is stopped,
#     or need to start multiple services in the one container
echo "##### running /script/dns_dhcp.sh ######"
#trap "echo TRAPed signal" HUP INT QUIT TERM

# start service in background here
/usr/bin/rsync --daemon --config=/etc/rsync/rsyncd.conf
#/usr/sbin/dhcpd -d --no-pid
/usr/sbin/sshd -D
service isc-dhcp-server start
service bind9 start

echo "[hit enter key to exit] or run 'docker stop <container>'"
read

# stop service and clean up here
#echo "stopping apache"
#/usr/sbin/apachectl stop
service isc-dhcp-server stop
service bind9 stop
kill `ps -axwu | grep -e [r]sync | awk '{print $2}'` 2> /dev/null
kill `ps -auxw | grep -e bin[\/][s][s]hd | awk '{print $2}'` 2> /dev/null

echo "exited $0"
