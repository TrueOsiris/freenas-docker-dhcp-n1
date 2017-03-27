# freenas-docker-dnsdhcp-node1
Docker instance tuned for FreeNas with isc-dhcp-server (ipv4) and bind9 dns as failover main node1

# clone / pull to docker host
git clone https://github.com/TrueOsiris/freenas-docker-dnsdhcp-node1
git pull https://github.com/TrueOsiris/freenas-docker-dnsdhcp-node1

# create the docker image
cd freenas-docker-dnsdhcp-node1
docker build -t dns-dhcp-node1 .

