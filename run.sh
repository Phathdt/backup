#!/usr/bin/env bash

echo "Dump Database"
START_TIME=`date +%s`
pg_dump -Z0 -j 10 -Fd $DB_NAME -U $DB_USERNAME -h $DB_HOST -p $DB_PORT -f dumpdir
tar -cf - dumpdir | pigz -p 10 > databasebackup.tar.gz
rm -rf dumpdir

CURRENT_TIME=$(date +'%Y.%m.%d.%H.%M.%S')

echo "Upload S3"
aws s3 cp ./databasebackup.tar.gz s3://$AWS_BUCKET/$AWS_PATH/$CURRENT_TIME/backup.tar.gz

rm ./databasebackup.tar.gz

echo "Delete old version"
aws s3api list-objects --bucket $AWS_BUCKET --prefix $AWS_PATH --query 'reverse(sort_by(Contents, &LastModified))' --output json > files.json

file_list=$(jq -r '.[7:] | .[].Key' files.json)
rm files.json

for file in $file_list; do
    aws s3 rm s3://$AWS_BUCKET/$file
done

END_TIME=`date +%s`
RUNTIMES=$((END_TIME-START_TIME))

ELAPSED_TIME="$((RUNTIMES/3600))h $(((RUNTIMES/60)%60))m $((RUNTIMES%60))s"

echo "Notify slack"
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
