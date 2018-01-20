#!/bin/bash

# Configure the mDNS hostname on ejabberd
if [ -n "${MDNS_HOSTNAME}" ]; then
    sed -i "s#{\[MDNS_HOSTNAME\]}#${MDNS_HOSTNAME}#g" /etc/ejabberd/ejabberd.yml
else
    sed -i "s#{\[MDNS_HOSTNAME\]}#localhost#g" /etc/ejabberd/ejabberd.yml
fi

# Setup the runtime ejabberd directory for pids and sockets
rm -rf /run/ejabberd
mkdir -p /run/ejabberd
chmod 0755 /run/ejabberd
chown ejabberd:ejabberd /run/ejabberd

# Start ejabberd in foreground for supervisord
exec /usr/sbin/ejabberdctl foreground
