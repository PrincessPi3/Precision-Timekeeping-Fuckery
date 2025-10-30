#!/bin/bash
numlogs=500
tmp_log="./chrony_statistics.log"

sudo tail -n $numlogs /var/log/chrony/statistics.log > $tmp_log
sudo chown $USER:$USER $tmp_log
echo "$(wc -l $tmp_log) logs entered"
python chrony_statistics.py
rm -f $tmp_log