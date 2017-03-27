# dns & dhcp servers: isc-dhcp-server & bind9
# split in 2 nodes: 1 main & 1 backup.
# relevant files flow from main to backup via rsync.

FROM ubuntu:latest

# MAINTAINER tim@chaubet.be

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y isc-dhcp-server \
 && apt-get install -y bind \
 && apt-get autoclean && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/* 
RUN mkdir /etc/rsync
RUN touch /var/lib/dhcp/dhcpd.leases
VOLUME ["/var/lib/dhcp", "/etc/dhcp", "/etc/bind", "/etc/rsync"]

ENTRYPOINT ["/usr/sbin/dhcpd", "-d", "--no-pid"]
ENTRYPOINT ["/usr/bin/rsync", "--daemon", "--config=/etc/rsync/rsyncd.conf"]

