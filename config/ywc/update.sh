#!/bin/bash

export SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
cd $SCRIPT_DIR/../..;
export YWC_HOME=`pwd`;
cd $YWC_HOME;

export YWC_APP=`cat config/app-name.txt`;

# update ywc core
git pull;

# update database for app
mysql -hlocalhost -uywc -pywcywc < database/ywc/ywccore.sql;
