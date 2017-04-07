#!/bin/sh
echo "root:test" | chpasswd
sed -i 's/^PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
/etc/init.d/ssh start
