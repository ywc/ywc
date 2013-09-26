#!/bin/bash

export SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
cd $SCRIPT_DIR/../..;
export YWC_HOME=`pwd`;
cd $YWC_HOME;

export YWC_APP=`cat config/app_name`;

# update ywc core
git pull;

# update core database
mysql -hlocalhost -uywc -pywcywc < database/ywc/ywccore.sql;

if [ ! -f config/$YWC_APP/update.sh ]; then
  config/$YWC_APP/update.sh;
fi

#/usr/bin/java -jar ywc.core/ywc.java/ywc.backend.d/dist/ywc.backend.d.jar
