#!/bin/bash
# Start the server
/var/vintagestory/server/server.sh start && tail -f /var/vintagestory/data/Logs/server-main.txt
