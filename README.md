# freenas-docker-dhcp-n1
Docker instance tuned for FreeNas with isc-dhcp-server (ipv4) in failover setup - primary node (1)

# clone / pull to docker host
git clone https://github.com/TrueOsiris/freenas-docker-dhcp-n1<br>
git pull https://github.com/TrueOsiris/freenas-docker-dhcp-n1

# create the docker image
cd freenas-docker-dhcp-n1<br>
docker build --tag dhcp-n1:latest .

# References used
https://docs.docker.com/docker-hub/builds/<br>
https://github.com/freenas/docker-images<br>
https://github.com/rubberbird/docker-zoneminder
