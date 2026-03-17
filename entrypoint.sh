#!/bin/bash
sudo service ssh start
sudo service cron start

echo -e "CTF Lab ready. SSH on port 3333 how to login?\nssh analyst@localhost -p 3333"
tail -f /dev/null
