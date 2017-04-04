# dhcp server: isc-dhcp-server
# split in 2 nodes: 1 main & 1 backup.
# relevant files should flow from main to backup via rsync.

FROM ubuntu:latest
MAINTAINER Tim Chaubet "tim@chaubet.be"

# Freenas container metadata
#/usr/sbin/dhcpd -q -cf /etc/dhcp/dhcpd.conf -pf /var/run/dhcpd.pid
LABEL description="This image is used to launch the isc-dhcp-server service" \
      version="0.0.2" \
      maintainer="tim@chaubet.be" \
      org.freenas.interactive="false" \
      org.freenas.command="/usr/sbin/dhcpd -q -cf /etc/dhcp/dhcpd.conf -pf /var/run/dhcpd.pid" \
      org.freenas.version="2" \
      org.freenas.privileged="false" \
      org.freenas.upgradeable="false" \
      org.freenas.expose-ports-at-host="true" \
      org.freenas.autostart="false" \
      org.freenas.port-mappings="67:67/udp,68:68/udp" \
      org.freenas.settings="[ \
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
      ]" \
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
      #org.freenas.static-volumes="[ \
      #    { \
      #        \"container_path\": \"/dev/rtc\",				\
      #        \"host_path\": \"/dev/rtc\",				\
      #        \"readonly\": \"true\"					\
      #    } \
      #]"
      #org.freenas.capabilities-add="NET_BROADCAST" \
      #org.freenas.web-ui-protocol="http" \
      #org.freenas.web-ui-port="80" \
      #org.freenas.web-ui-path="zm" \

#USER root

#add repository and update the container
#Installation of nesesary package/software for this containers...
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y isc-dhcp-server \
 && apt-get autoclean && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* /var/tmp/* \
 && touch /var/lib/dhcp/dhcpd.leases
 #&& apt-get install -y bind9 \

COPY entrypoint.sh /scripts/
ADD entrypoint.sh /scripts/

# test VOLUME parameter
#VOLUME ["/var/lib/dhcp", "/etc/dhcp", "/scripts"]
EXPOSE 67 68

#ENTRYPOINT ["/usr/sbin/dhcpd", "-d", "--no-pid"]
#ENTRYPOINT ["/usr/bin/rsync", "--daemon", "--config=/etc/rsync/rsyncd.conf"]
ENTRYPOINT ["/scripts/entrypoint.sh"]
