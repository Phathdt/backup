#!/bin/bash
echo running the cronjob...
rsyslogd && cron && tail -f /var/log/syslog /var/log/cron.log   # run the cronjob