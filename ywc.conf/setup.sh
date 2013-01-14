#!/bin/bash
export YWC_HOME=/data/ywc
mkdir $YWC_HOME/ywc.cache
mkdir $YWC_HOME/ywc.cache/doc $YWC_HOME/ywc.cache/tmp $YWC_HOME/ywc.cache/txt $YWC_HOME/ywc.cache/xml
mkdir $YWC_HOME/ywc.cache/doc/orig $YWC_HOME/ywc.cache/doc/temp $YWC_HOME/ywc.cache/doc/thmb $YWC_HOME/ywc.cache/doc/work
mkdir $YWC_HOME/ywc.cache/tmp/gen $YWC_HOME/ywc.cache/tmp/img $YWC_HOME/ywc.cache/tmp/ing $YWC_HOME/ywc.cache/tmp/txt $YWC_HOME/ywc.cache/tmp/upl $YWC_HOME/ywc.cache/tmp/xml
mkdir $YWC_HOME/ywc.cache/xml/cache $YWC_HOME/ywc.cache/xml/data
cp $YWC_HOME/ywc.conf/data.xml $YWC_HOME/ywc.cache/xml/data/cache.xml
cp $YWC_HOME/ywc.conf/data.xml $YWC_HOME/ywc.cache/xml/data/include.xml
cp $YWC_HOME/ywc.conf/data.xml $YWC_HOME/ywc.cache/xml/data/placeholder.xml
cp $YWC_HOME/ywc.conf/data.xml $YWC_HOME/ywc.cache/xml/data/scope.xml
cp $YWC_HOME/ywc.conf/data.xml $YWC_HOME/ywc.cache/xml/data/template.xml
cp $YWC_HOME/ywc.conf/data.xml $YWC_HOME/ywc.cache/xml/data/transform.xml
cp $YWC_HOME/ywc.conf/data.xml $YWC_HOME/ywc.cache/xml/data/uri.xml
cp $YWC_HOME/ywc.conf/data.xml $YWC_HOME/ywc.cache/xml/data/user.xml
chmod -Rf a+rw $YWC_HOME/ywc.cache