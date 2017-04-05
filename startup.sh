set -e

if [ -f /etc/configured ]; then
        echo 'already configured'
        
        /sbin/zm.sh&
else      
        #check if Directories inside of /etc/dhcp are present.
        if [ ! -d /etc/dhcp ]; then
           mkdir -p /etc/dhcp
        fi
        
        chmod -R 770 /etc/dhcp
        
        #needed to fix problem with ubuntu ... and cron 
        update-locale
        date > /etc/configured
fi
