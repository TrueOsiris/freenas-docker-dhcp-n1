set -e

if [ -f /config/configured ]; then
        echo 'already configured'
else      
        #check if Directories inside of /etc/dhcp are present.
        if [ ! -d /config/dhcp ]; then
           mkdir -p /config/dhcp
        fi
        
        chmod -R 775 /config/dhcp
        
        #needed to fix problem with ubuntu ... and cron 
        if [ ! -f /config/dhcp/dhcpd.conf ]; then
            cp test.txt /config/dhcp/dhcpd.conf 2>&1
            cp /tmp/test.txt /config/dhcp/added_test.txt 2>&1
        fi
        update-locale
        date > /config/configured
fi
