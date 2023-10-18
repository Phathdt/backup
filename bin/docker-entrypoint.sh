#!/bin/bash
echo running backup
echo $DB_NAME
echo $AWS_ACCESS_KEY_ID
env
cd /root/Backup && backup perform -t databasebackup
