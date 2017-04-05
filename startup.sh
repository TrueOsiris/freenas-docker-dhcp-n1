set -e

if [ -f /config/configured ]; then
        echo 'already configured'
else      
        #check if Directories inside of /etc/dhcp are present.
        if [ ! -d /config/dhcp ]; then
           mkdir -p /config/dhcp
        fi
        
        chmod -R 775 /config/dhcp
        
        if [ ! -f /config/dhcp/dhcpd.conf ]; then
            cp /tmp/test.txt /config/dhcp/added_test.txt
        fi
        update-locale
        date > /config/configured
fi
