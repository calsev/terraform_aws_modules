#!/bin/bash
set -e

if [ ! -d /usr/local/openvpn_as/etc ]; then
    echo "Seeding full openvpn_as directory"
    cp -a /var/opt/openvpn_as/* /usr/local/openvpn_as/
fi

# Let upstream do symlink dance and DB migrations
/docker-entrypoint.sh true

# Idempotent admin password setup
if [ -n "$OPENVPN_ADMIN_PASSWORD" ]; then
  if ! /usr/local/openvpn_as/scripts/sacli --user openvpn UserPropGet > /dev/null 2>&1; then
    echo "Creating admin password"
    /usr/local/openvpn_as/scripts/sacli --user openvpn --new_pass="$OPENVPN_ADMIN_PASSWORD" SetLocalPassword
  fi
fi

# Idempotent license activation
if [ -n "$OPENVPN_LICENSE_KEY" ]; then
  if ! /usr/local/openvpn_as/scripts/liman Info | grep -q '"activated": true'; then
    echo "Activating license"
    /usr/local/openvpn_as/scripts/liman Activate "$OPENVPN_LICENSE_KEY"
  fi
fi

exec "$@"
