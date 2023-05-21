#!/bin/bash

cleanup() {
    echo "Container stopped, performing cleanup..."
    /var/vintagestory/server/server.sh stop
}

# Trap SIGTERM
trap 'cleanup' SIGTERM

# Start the server
/var/vintagestory/server/server.sh start && tail -f /var/vintagestory/data/Logs/server-main.txt &
# Wait
wait $!
