#!/bin/bash

export YWC_HOME=/data/ywc

mkdir $YWC_HOME/cache
mkdir $YWC_HOME/cache/doc $YWC_HOME/cache/tmp $YWC_HOME/cache/txt $YWC_HOME/cache/xml
mkdir $YWC_HOME/cache/doc/orig $YWC_HOME/cache/doc/temp $YWC_HOME/cache/doc/thmb $YWC_HOME/cache/doc/work
mkdir $YWC_HOME/cache/tmp/gen $YWC_HOME/cache/tmp/img $YWC_HOME/cache/tmp/ing $YWC_HOME/cache/tmp/txt $YWC_HOME/cache/tmp/upl $YWC_HOME/cache/tmp/xml
mkdir $YWC_HOME/cache/xml/cache $YWC_HOME/cache/xml/data
cp $YWC_HOME/config/data.xml $YWC_HOME/cache/xml/data/cache.xml
cp $YWC_HOME/config/data.xml $YWC_HOME/cache/xml/data/include.xml
cp $YWC_HOME/config/data.xml $YWC_HOME/cache/xml/data/placeholder.xml
cp $YWC_HOME/config/data.xml $YWC_HOME/cache/xml/data/scope.xml
cp $YWC_HOME/config/data.xml $YWC_HOME/cache/xml/data/template.xml
cp $YWC_HOME/config/data.xml $YWC_HOME/cache/xml/data/transform.xml
cp $YWC_HOME/config/data.xml $YWC_HOME/cache/xml/data/uri.xml
cp $YWC_HOME/config/data.xml $YWC_HOME/cache/xml/data/user.xml
chmod -Rf a+rw $YWC_HOME/cache;

# cd $YWC_HOME/config/;
# ./update_code.sh;
# ./update_cache.sh;
