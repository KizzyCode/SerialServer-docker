#!/bin/sh
set -euo pipefail


# Prepare device variables
export DEVICE_PATH="${DEVICE_PATH}"
export DEVICE_BAUDS="${DEVICE_BAUDS:-115200}"
export UDP_LISTEN="${UDP_LISTEN}"


# Export optional UDP variables
if test -n "${UDP_SEND:-}"; then
    export UDP_SEND_TEMPLATE="send = \"${UDP_SEND}\""
else
    export UDP_SEND_TEMPLATE="#send = \"224.0.0.1:6666\""
fi

if test -n "${UDP_TTL:-}"; then
    export UDP_TTL_TEMPLATE="ttl = \"${UDP_TTL}\""
else
    export UDP_TTL_TEMPLATE="#ttl = 0"
fi


# Create config file
cat "/etc/serial-server.toml.template" | envsubst > "/etc/serial-server.toml"
exec /usr/local/bin/serial-server "/etc/serial-server.toml"
