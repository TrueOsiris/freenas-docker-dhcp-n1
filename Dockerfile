# dns & dhcp servers: isc-dhcp-server & bind9
# split in 2 nodes: 1 main & 1 backup.
# relevant files flow from main to backup via rsync.

FROM ubuntu:latest
LABEL description="This image is used to launch the isc-dhcp-server & the bind9 named/dns server" \
      version="0.0.2" \
      maintainer="tim@chaubet.be" \
      org.freenas.interactive="true" \
      org.freenas.version="0.0.2" \
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

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y isc-dhcp-server \
 && apt-get install -y bind9 \
 && apt-get autoclean && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* /var/tmp/* \
 && touch /var/lib/dhcp/dhcpd.leases \
 && mkdir -p /etc/service/dns-dhcp /var/log/dns-dhcp ; sync
 
#VOLUME ["/var/lib/dhcp", "/etc/dhcp", "/etc/bind", "/etc/rsync", "/script"]
#COPY /script/dns-dhcp.sh /script/dns-dhcp.sh

ADD base/etc/* /etc/
# add daemons to runit
COPY base/script/dns-dhcp.sh /etc/service/dns-dhcp/run 
COPY base/script/dns-dhcp.sh /scripts/

RUN chmod +x /etc/service/dns-dhcp/run \ 
 && cp /var/log/cron/config /var/log/dns-dhcp/ 


#ENTRYPOINT ["/usr/sbin/dhcpd", "-d", "--no-pid"]
#ENTRYPOINT ["/usr/bin/rsync", "--daemon", "--config=/etc/rsync/rsyncd.conf"]
ENTRYPOINT ["/scripts/dns-dhcp.sh"]
