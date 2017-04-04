# freenas-docker-dnsdhcp-node1
Docker instance tuned for FreeNas with isc-dhcp-server (ipv4) and bind9 dns as failover main node1

# clone / pull to docker host
git clone https://github.com/TrueOsiris/freenas-docker-dnsdhcp-node1<br>
git pull https://github.com/TrueOsiris/freenas-docker-dnsdhcp-node1

# create the docker image
cd freenas-docker-dnsdhcp-node1<br>
docker build --tag dns-dhcp-node1:latest .

# References used
https://github.com/freenas/docker-images<br>
https://github.com/rubberbird/docker-zoneminder
