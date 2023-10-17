# encoding: utf-8

Model.new(:databasebackup, ENV["BACKUP_NAME_DATABASE"]) do
  database PostgreSQL do |db|
    db.name               = ENV["DB_NAME"]
    db.username           = ENV["DB_USERNAME"]
    db.password           = ENV["DB_PASSWORD"]
    db.host               = ENV["DB_HOST"]
    db.port               = ENV["DB_PORT"]
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip

  ##
  # Amazon Simple Storage Service [Storage]
  store_with S3 do |s3|
     s3.access_key_id     = ENV["AWS_ACCESS_KEY_ID"]
     s3.secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
     s3.region            = ENV["AWS_REGION"]
     s3.bucket            = ENV["AWS_BUCKET"]
     s3.path              = ENV["AWS_PATH"]
     s3.keep              = ENV["AWS_S3_KEEP"] ? ENV["AWS_S3_KEEP"].to_i : 5
  end

  # notify_by Slack do |slack|
  #   slack.on_success = true
  #   slack.on_warning = true
  #   slack.on_failure = true

  #   # The integration token
  #   slack.webhook_url = ENV["BACKUP_SLACK_WEBHOOK_URL"]   # the webhook_url
  #   slack.username = ENV["BACKUP_SLACK_USERNAME"]   # the username to display along with the notification
  #   slack.channel = ENV["BACKUP_SLACK_CHANNEL"]   # the channel to which the message will be sent
  #   slack.icon_emoji = ENV["BACKUP_SLACK_ICON_EMOJI"]   # the emoji icon to use for notifications
  # end

end
