set -e

if [ -f /config/configured ]; then
        echo 'already configured'
else      
        #check if Directories inside of /etc/dhcp are present.
        if [ ! -d /config/dhcp ]; then
           mkdir -p /config/dhcp
        fi
        
        chmod -R 770 /config/dhcp
        
        #needed to fix problem with ubuntu ... and cron 
        update-locale
        cp test.txt /config/test.txt
        date > /config/configured
fi
