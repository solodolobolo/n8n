#!/bin/sh

USER_ID=${PUID:-1000}
GROUP_ID=${PGID:-1000}

if ! getent group node >/dev/null; then
    groupadd -o -g "$GROUP_ID" node
fi

if ! getent passwd node >/dev/null; then
    useradd -o -u "$USER_ID" -g "$GROUP_ID" -d /home/node -m -s /bin/sh node
fi

chown -R node:node /home/node

exec su-exec node n8n