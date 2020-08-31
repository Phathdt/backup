#!/bin/bash
echo running backup
cd /root/Backup && backup perform -t filebackup,databasebackup
