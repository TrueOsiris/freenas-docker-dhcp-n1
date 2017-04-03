# dns & dhcp servers: isc-dhcp-server & bind9
# split in 2 nodes: 1 main & 1 backup.
# relevant files flow from main to backup via rsync.

FROM ubuntu:latest
LABEL description="This image is used to launch the isc-dhcp-server & the bind9 named/dns server" \
      version="0.0.2" \
      maintainer="tim@chaubet.be" \
      org.freenas.interactive="true" \
      org.freenas.privileged="false" \
      org.freenas.upgradeable="true" \
      org.freenas.expose-ports-at-host="true" \
      org.freenas.autostart="true" \
      org.freenas.capabilities-add="NET_BROADCAST" \
      org.freenas.port-mappings="6000:6000/tcp" \
      org.freenas.volumes="[ \
          { \
              \"name\": \"/config\", \
              \"descr\": \"Config storage space\" \
          }, \
          {	\
              \"name\": \"/scripts\", \
              \"descr\": \"Scripts Volume\" \
          }	\
      ]" \
      org.freenas.settings="[ \
          {								\
              \"env\": \"TZ\",						\
              \"descr\": \"Timezone - eg Europe/London\",		\
              \"optional\": true					\
          },								\
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
              \"env\": \"PGID\", \
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
# && apt-get install -y openssh-server \
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y isc-dhcp-server \
 && apt-get install -y bind9 \
 && apt-get autoclean && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/* \
 && touch /var/lib/dhcp/dhcpd.leases \
 && mkdir /scripts
#VOLUME ["/var/lib/dhcp", "/etc/dhcp", "/etc/bind", "/etc/rsync", "/script"]
#COPY /script/dns-dhcp.sh /script/dns-dhcp.sh
ADD base/etc/* /etc/
ADD base/script/* /scripts/

#ENTRYPOINT ["/usr/sbin/dhcpd", "-d", "--no-pid"]
#ENTRYPOINT ["/usr/bin/rsync", "--daemon", "--config=/etc/rsync/rsyncd.conf"]
ENTRYPOINT ["/script/dns-dhcp.sh"]
