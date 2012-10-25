#!/bin/bash

echo 'updating to latest core ywc db...';
svn up /data/ywc/ywc.db/ywc/

echo 'loading core ywc data into local database...';
mysql -hlocalhost -uywc -pywcywc < /data/ywc/ywc.db/ywc/ywccore.sql;

echo 'converting ywc database into xml...';
/usr/bin/java -jar /data/ywc/ywc.core/ywc.java/ywc.backend.d/dist/ywc.backend.d.jar;