# dns & dhcp servers: isc-dhcp-server & bind9
# split in 2 nodes: 1 main & 1 backup.
# relevant files flow from main to backup via rsync.

FROM ubuntu:latest
LABEL description="This image is used to launch the isc-dhcp-server & the bind9 named/dns server" \
      version="1.0" \
      maintainer="tim@chaubet.be" \
      org.freenas.interactive="false" \
      org.freenas.privileged="false" \
      org.freenas.upgradeable="false" \
      org.freenas.expose-ports-at-host="true" \
      org.freenas.autostart="true" \
      org.freenas.capabilities-add="NET_BROADCAST" \
      org.freenas.volumes="[ \
          { \
              \"name\": \"/config\", \
              \"descr\": \"Config storage space\" \
          } \
      ]" \
      org.freenas.settings="[ \
          { \
              \"env\": \"HOSTNAME\", \
              \"descr\": \"Container Hostname\", \
              \"optional\": true \
          }, \
          { \
              \"env\": \"ALLOWED_NETWORKS\", \
              \"descr\": \"IP/mask[,IP/mask]\", \
              \"optional\": true \
          }, \
          { \
              \"env\": \"PUID\", \
              \"descr\": \"User ID\", \
              \"optional\": true \
          }, \
          { \
              \"env\": \"GUID\", \
              \"descr\": \"Group ID\", \
              \"optional\": true \
          } \
      ]"
USER root


# && mkdir /script/ \
# && mkdir -p /etc/bind/zones \
# && mkdir -p /etc/rsync \
# && mkdir -p /var/lib/dhcp \
# && mkdir -p /etc/dhcp \
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y isc-dhcp-server \
 && apt-get install -y bind9 \
 && apt-get install openssh-server \
 && apt-get autoclean && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/* \
 && touch /var/lib/dhcp/dhcpd.leases
#VOLUME ["/var/lib/dhcp", "/etc/dhcp", "/etc/bind", "/etc/rsync", "/script"]
#COPY /script/dns-dhcp.sh /script/dns-dhcp.sh

#ENTRYPOINT ["/usr/sbin/dhcpd", "-d", "--no-pid"]
#ENTRYPOINT ["/usr/bin/rsync", "--daemon", "--config=/etc/rsync/rsyncd.conf"]
ENTRYPOINT ["/script/dns-dhcp.sh"]
