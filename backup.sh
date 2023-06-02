#!/bin/sh

# Run the backup command
/var/vintagestory/server/server.sh command genbackup

# Navigate to the backup directory
cd /var/vintagestory/data/Backups

# Delete all but the 7 most recent backups in the backups folder
ls -t | tail -n +8 | xargs -I {} rm -- {}
