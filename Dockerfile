# dhcp server: isc-dhcp-server
# WORK IN PROGRESS
# split in 2 nodes: 1 main & 1 backup.
# relevant files should flow from main to backup via rsync.

# FROM ubuntu:latest
FROM quantumobject/docker-baseimage:16.04
MAINTAINER Tim Chaubet "tim@chaubet.be"

# Freenas container metadata
#/usr/sbin/dhcpd -q -cf /etc/dhcp/dhcpd.conf -pf /var/run/dhcpd.pid
LABEL description="This image is used to launch the isc-dhcp-server service" \
      version="0.0.2" \
      maintainer="tim@chaubet.be" \
      org.freenas.interactive="true" \
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
      ]" 
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
      #org.freenas.command="/usr/sbin/dhcpd -q -cf /etc/dhcp/dhcpd.conf -pf /var/run/dhcpd.pid" \

#USER root

#add repository and update the container
#Installation of nesesary package/software for this containers...
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y isc-dhcp-server \
 && apt-get autoclean -y \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* /var/tmp/* \
 && touch /var/lib/dhcp/dhcpd.leases
 #&& apt-get install -y bind9 \

# add dhcpd daemon to runit
RUN mkdir -p /etc/service/dhcpd /var/log/dhcpd ; sync
COPY dhcpd.sh /etc/service/dhcpd/run
RUN chmod +x /etc/service/dhcpd/run \
    && cp /var/log/cron/config /var/log/dhcpd/ 
    
# to add ntp deamon to runit
RUN mkdir -p /etc/service/ntp  /var/log/ntp ; sync 
COPY ntp.sh /etc/service/ntp/run
RUN chmod +x /etc/service/ntp/run \
    && cp /var/log/cron/config /var/log/ntp/ \
    && chown -R nobody /var/log/ntp

#######################
### startup scripts ###
#######################

#Pre-config scrip that maybe need to be run one time only when the container run the first time .. using a flag to don't 
#run it again ... use for conf for service ... when run the first time ...
RUN mkdir -p /etc/my_init.d
COPY startup.sh /etc/my_init.d/startup.sh
RUN chmod +x /etc/my_init.d/startup.sh

#pre-config scritp for different service that need to be run when container image is create 
#maybe include additional software that need to be installed ... with some service running ... like example mysqld
#COPY pre-conf.sh /sbin/pre-conf
#RUN chmod +x /sbin/pre-conf ; sync \
#    && /bin/bash -c /sbin/pre-conf \
#    && rm /sbin/pre-conf
    


# test VOLUME parameter
#VOLUME ["/var/lib/dhcp", "/etc/dhcp", "/scripts"]
VOLUME /var/test

# expose ports to the outside
EXPOSE 67 68

RUN echo "!/bin/sh ntpdate 0.europe.pool.ntp.org" >> /etc/cron.daily/ntpdate \
    && chmod 750 /etc/cron.daily/ntpdate

#ENTRYPOINT ["/usr/sbin/dhcpd", "-d", "--no-pid"]
#ENTRYPOINT ["/usr/bin/rsync", "--daemon", "--config=/etc/rsync/rsyncd.conf"]
#ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["/sbin/my_init"]
