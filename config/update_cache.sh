#!/bin/bash

export YWC_HOME=/data/ywc;
export REMOTE_DIR=/version/git/oist-ywc;
export YWC_APP=oist;
export REPO_NAME=oist-tida;

# pre cleanup
rm -Rf /tmp/oist-tida.tar.gz /tmp/oist-tida;

# checkout and clean repo on remote server
ssh login.oist.jp "rm -Rf $REMOTE_DIR/tmp; mkdir $REMOTE_DIR/tmp; git clone file://$REMOTE_DIR/oist-tida.git $REMOTE_DIR/tmp/oist-tida; cd $REMOTE_DIR/tmp/oist-tida; rm -rf \`find . -type d -name .git\`; cd $REMOTE_DIR/tmp; tar -zvcf oist-tida.tar.gz oist-tida;";

wait;
# copy code over to local server
scp login.oist.jp:$REMOTE_DIR/tmp/oist-tida.tar.gz /tmp/oist-tida.tar.gz;
cd /tmp/;
tar -zxvf /tmp/oist-tida.tar.gz;
 
# copy directories into correct locations
if [ ! -f /tmp/oist-tida ]; then
 sudo rm -Rf /data/ywc/public/oist /data/ywc/database/oist /data/ywc/xsl/oist;
 sudo mv /tmp/oist-tida/public/oist /data/ywc/public/oist;
 sudo mv /tmp/oist-tida/database/oist /data/ywc/database/oist;
 sudo mv /tmp/oist-tida/xsl/oist /data/ywc/xsl/oist;
fi

# post cleanup
ssh login.oist.jp "rm -Rf $REMOTE_DIR/tmp;";
rm -Rf /tmp/oist-tida.tar.gz /tmp/oist-tida;

# update database for app
mysql -hlocalhost -uywc -pywcywc < /data/ywc/database/oist/ywcoist.sql;

# update ywc core
cd $YWC_HOME;
sudo git pull;