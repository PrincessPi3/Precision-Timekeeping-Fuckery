#!/bin/bash
git pull
bash services.sh stop
bash nuke_logs.sh
bash cleanup.sh