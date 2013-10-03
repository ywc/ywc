#!/bin/bash

export YWC_LOCATION=`pwd`;
export YWC_HOME=$YWC_LOCATION/ywc;

git clone https://github.com/ywc/ywc.git $YWC_HOME;

cd $YWC_HOME;

echo "Enter the YWC app 'name': ";
read APP_NAME;
echo "Your app will be named '$APP_NAME'.";
echo $APP_NAME > config/app_name;
echo "UNFIXED BUG!!!!! PLEASE REMOVE TRAILING CARRIAGE RETURN IN APP_NAME FILE!!!";

if [ ! -d cache ]; then
  mkdir cache cache/doc cache/tmp cache/txt cache/xml cache/doc/orig cache/doc/temp cache/doc/thmb cache/doc/work cache/tmp/gen cache/tmp/img cache/tmp/ing cache/tmp/txt cache/tmp/upl cache/tmp/xml cache/xml/cache cache/xml/data;
  cat config/ywc/templates/data-default.xml | tee cache/xml/data/cache.xml cache/xml/data/include.xml cache/xml/data/placeholder.xml cache/xml/data/scope.xml cache/xml/data/template.xml cache/xml/data/transform.xml cache/xml/data/uri.xml cache/xml/data/user.xml > /dev/null;
fi
chmod -Rf 1777 cache ywc.core/ywc.core/xml/data;

yum install -y tomcat6 tomcat6-webapps tomcat6-admin-webapps ImageMagick;

# publish latest WARs & JARs
config/ywc/publish.sh;

# add node to server.xml so that tomcat also runs on 8081
#vi ~tomcat/conf/server.xml

service tomcat6 restart;
service httpd restart;

