#!/bin/bash

export YWC_LOCATION=`pwd`;
export YWC_HOME=$YWC_LOCATION/ywc;

git clone https://github.com/ywc/ywc.git $YWC_HOME;

cd $YWC_HOME;

if [ ! -d cache ]; then
  mkdir cache cache/doc cache/tmp cache/txt cache/xml cache/doc/orig cache/doc/temp cache/doc/thmb cache/doc/work cache/tmp/gen cache/tmp/img cache/tmp/ing cache/tmp/txt cache/tmp/upl cache/tmp/xml cache/xml/cache cache/xml/data;
  cat config/ywc/templates/data-default.xml | tee cache/xml/data/cache.xml cache/xml/data/include.xml cache/xml/data/placeholder.xml cache/xml/data/scope.xml cache/xml/data/template.xml cache/xml/data/transform.xml cache/xml/data/uri.xml cache/xml/data/user.xml > /dev/null;
fi
chmod -Rf 1777 cache ywc.core/ywc.core/xml/data;

yum install -y tomcat6 tomcat6-webapps tomcat6-admin-webapps ImageMagick;

# add node to server.xml so that tomcat also runs on 8081
#vi ~tomcat/conf/server.xml

# curl -s -L https://raw.github.com/ywc/ywc/master/config/ywc/install.sh -o install-ywc.sh; chmod a+x install-ywc.sh; ./install-ywc.sh;