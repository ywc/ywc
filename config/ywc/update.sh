#!/bin/bash

export SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
cd $SCRIPT_DIR/../..;
export YWC_HOME=`pwd`;

export YWC_APP=`cat config/app_name`;

# pulling in latest core
git pull;

config/ywc/reset_app_version.sh;

# rebuilding SQLite databases
rm database/ywc/ywccore.sqlite3 database/$YWC_APP/ywc$YWC_APP.sqlite3;
sqlite3 database/ywc/ywccore.sqlite3 < database/ywc/ywccore.sqlite.sql;
sqlite3 database/$YWC_APP/ywc$YWC_APP.sqlite3 < database/$YWC_APP/ywc$YWC_APP.sqlite.sql;
chmod a+rwx database/ywc/ywccore.sqlite3 database/$YWC_APP/ywc$YWC_APP.sqlite3;

if [ "$1" == "full" ]; then
  config/ywc/publish.sh;
fi

/usr/bin/java -jar ywc.core/ywc.java/ywc.backend.d/dist/ywc.backend.d.jar "xml_generate";

if [ "$1" == "full" ]; then
  config/ywc/cache.sh;
fi