#!/bin/bash

export SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
cd $SCRIPT_DIR/../..;
export YWC_HOME=`pwd`;
cd $YWC_HOME;

export YWC_APP=`cat config/app_name`;

# update ywc databases (core and app)
rm database/ywc/ywccore.sqlite3 database/$YWC_APP/ywc$YWC_APP.sqlite3;
echo "updating ywc database...";
sqlite3 database/ywc/ywccore.sqlite3 < database/ywc/ywccore.sqlite.sql;
echo "updating $YWC_APP database...";
sqlite3 database/$YWC_APP/ywc$YWC_APP.sqlite3 < database/$YWC_APP/ywc$YWC_APP.sqlite.sql;
chmod a+rwx database/ywc/ywccore.sqlite3 database/$YWC_APP/ywc$YWC_APP.sqlite3;
