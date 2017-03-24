FROM ubuntu:latest

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
