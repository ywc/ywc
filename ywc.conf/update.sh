#!/bin/bash

# navigate to ywc home
cd /data/ywc/;

# set app name
export YWC_APP=oist;

# update lib assets for app
cd ywc.lib/$YWC_APP/;
svn cleanup;
svn up;

# update xsl assets for app
cd ../../ywc.xsl/$YWC_APP/;
svn cleanup;
svn up;

# update database for app
cd ../../ywc.db/$YWC_APP/;
svn cleanup;
svn up;
mysql -hlocalhost -uywc -pywcywc < ywcoist.sql;

# update ywc core
cd ../../;
git pull;

cd ywc.core/ywc.java/build;
./build.sh;