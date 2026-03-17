#!/bin/bash
CONFIG=/home/analyst/.backup.conf
if [ -f "$CONFIG" ]; then
    source $CONFIG
fi
tar -czf /tmp/backup.tar.gz /home/analyst/*
