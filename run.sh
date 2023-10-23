#!/usr/bin/env bash

START_TIME=`date +%s`
pg_dump -Z0 -j 10 -Fd $DB_NAME -U $DB_USERNAME -h $DB_HOST -p $DB_PORT -f dumpdir
tar -cf - dumpdir | pigz -p 10 > databasebackup.tar.gz
rm -rf dumpdir

CURRENT_TIME=$(date +'%Y.%m.%d.%H.%M.%S')

aws s3 cp ./databasebackup.tar.gz s3://$AWS_BUCKET/$AWS_PATH/$CURRENT_TIME/backup.tar.gz

rm ./databasebackup.tar.gz

END_TIME=`date +%s`
RUNTIMES=$((END_TIME-START_TIME))

ELAPSED_TIME="$((RUNTIMES/3600))h $(((RUNTIMES/60)%60))m $((RUNTIMES%60))s"
echo $ELAPSED_TIME


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
        {
          \"title\": \"Elapsed Time\",
          \"value\": \"$ELAPSED_TIME\",
          \"short\": false
        }
      ]
    }
  ]
}" $SLACK_WEBHOOK_URL
