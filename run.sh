#!/usr/bin/env bash

pg_dump -Z0 -j 10 -Fd $DB_NAME -U $DB_USERNAME -h $DB_HOST -p $DB_PORT -f dumpdir
tar -cf - dumpdir | pigz -p 10 > databasebackup.tar.gz
rm -rf dumpdir

CURRENT_TIME=$(date +'%Y.%m.%d.%H.%M.%S')

aws s3 cp ./databasebackup.tar.gz s3://$AWS_BUCKET/$AWS_PATH/$CURRENT_TIME/backup.tar.gz

rm ./databasebackup.tar.gz


curl -X POST -H 'Content-type: application/json' --data "{
  \"text\": \"[Backup::Success] $DB_NAME to $AWS_PATH S3\",
  \"attachments\": [
    {
      \"fields\": [
        {
          \"title\": \"Path S3\",
          \"value\": \"$AWS_BUCKET/$AWS_PATH/$CURRENT_TIME/backup.tar.gz\",
          \"short\": false
        },
      ]
    }
  ]
}" $SLACK_WEBHOOK_URL
