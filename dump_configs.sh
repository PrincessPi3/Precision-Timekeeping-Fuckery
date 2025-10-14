#!/bin/bash
set -e

if [ -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

