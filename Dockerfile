# dns & dhcp servers: isc-dhcp-server & bind9
# split in 2 nodes: 1 main & 1 backup.
# relevant files flow from main to backup via rsync.

FROM ubuntu:latest
LABEL description="This image is used to launch the isc-dhcp-server & the bind9 named/dns server" version="1.0" maintainer="tim@chaubet.be"
USER root
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y isc-dhcp-server \
 && apt-get install -y bind9 \
 && apt-get autoclean && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/* 
RUN mkdir /script/
RUN mkdir /etc/bind/zones
RUN mkdir /etc/rsync
RUN touch /var/lib/dhcp/dhcpd.leases
VOLUME ["/var/lib/dhcp", "/etc/dhcp", "/etc/bind", "/etc/rsync", "/script"]

#ENTRYPOINT ["/usr/sbin/dhcpd", "-d", "--no-pid"]
#ENTRYPOINT ["/usr/bin/rsync", "--daemon", "--config=/etc/rsync/rsyncd.conf"]
ENTRYPOINT ["/script/dns-dhcp.sh"]
