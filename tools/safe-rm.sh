#!/bin/sh

sudo apt install -y trash-cli autotrash
sudo sh -c "echo alias rm='trash' >> /etc/profile"

# Install cron job, auto empty trash for 5 days old
#write out current crontab
crontab -l > /tmp/auto-empty-trash
#echo new cron into cron file
echo "@daily /usr/bin/autotrash -d 5" >> /tmp/auto-empty-trash
#install new cron file
crontab /tmp/auto-empty-trash
rm /tmp/auto-empty-trash
