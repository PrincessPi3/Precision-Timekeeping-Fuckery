#!/bin/bash
echo "Nuking all those stupid files"
rm -f influxdata-archive.key 2>/dev/null
rm -f status.txt 2>/dev/null
rm -f *.tar.gz 2>/dev/null
rm -f *.log 2>/dev/null
rm -f *.bak* 2>/dev/null
rm -f *.~ 2>/dev/null
rm -rf old 2>/dev/null
rm -rf conf-* 2>/dev/null

echo "Git pulling"
git pull 1>/dev/null 2>/dev/null

echo "Cleanup done!"