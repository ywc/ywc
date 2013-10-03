#!/bin/bash

export SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
cd $SCRIPT_DIR/../..;
export YWC_HOME=`pwd`;

curl -L http://ywc.github.io/ywc-java/ywc.frontend.war?$RANDOM -o /tmp/fws.war;
curl -L http://ywc.github.io/ywc-java/ywc.backend.ws.war?$RANDOM -o /tmp/bws.war;
curl -L http://ywc.github.io/ywc-java/ywc.backend.d.tar.gz?$RANDOM -o /tmp/ywc.backend.d.tar.gz;

sudo mv /tmp/fws.war /var/lib/tomcat6/webapps/fws.war;
sudo mv /tmp/bws.war /var/lib/tomcat6/webapps/bws.war;

cd /tmp;
tar -zxvf /tmp/ywc.backend.d.tar.gz;
sudo rm -R $YWC_HOME/ywc.core/ywc.java/ywc.backend.d/dist/lib $YWC_HOME/ywc.core/ywc.java/ywc.backend.d/dist/ywc.backend.d.jar;
sudo cp -R /tmp/ywc.backend.d/lib $YWC_HOME/ywc.core/ywc.java/ywc.backend.d/dist/lib;
sudo cp /tmp/ywc_backend_d/ywc.backend.d.jar $YWC_HOME/ywc.core/ywc.java/ywc.backend.d/dist/ywc.backend.d.jar;
rm -Rf /tmp/ywc.backend.d /tmp/ywc.backend.d.tar.gz;