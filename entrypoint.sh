#!/bin/bash
sudo service ssh start
sudo service cron start

echo "CTF Lab ready. SSH on port 2222."
tail -f /dev/null
