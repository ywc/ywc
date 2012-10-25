
export YWC_HOME=../../..
export TOMCAT6_WEBAPPS=/var/lib/tomcat6/webapps
export ANT_HOME=$YWC_HOME/ywc.core/ywc.java/build/lib/apache-ant-1.8.2
export ANT_BIN=$ANT_HOME/bin/ant
export ANT_OPTIONS="-Dj2ee.server.home=/usr/share/tomcat6 -q"

echo "restarting memcached..."
service memcached restart

## links
ln -f -s $YWC_HOME/ywc.core/ywc.java/build/lib/lib-tomcat7/servlet-api.jar /usr/share/tomcat6/lib/servlet-api.jar

## build core
cd $YWC_HOME/ywc.core/ywc.java/ywc.core
$ANT_BIN $ANT_OPTIONS
echo "build core finished"

## build fws
echo "build fws..."
cd $YWC_HOME/ywc.core/ywc.java/ywc.frontend
$ANT_BIN $ANT_OPTIONS
cp dist/ywc.frontend.war $TOMCAT6_WEBAPPS/fws.war
echo "build fws finished"

## build bws
echo "build bws..."
cd $YWC_HOME/ywc.core/ywc.java/ywc.backend.ws
$ANT_BIN $ANT_OPTIONS
cp dist/ywc.backend.ws.war $TOMCAT6_WEBAPPS/bws.war
echo "build bws finished"
#
## build backend.d
echo "build backend.d..."
cd $YWC_HOME/ywc.core/ywc.java/ywc.backend.d
$ANT_BIN $ANT_OPTIONS
echo "build backend.d finished"

## run backend.d
echo "run backend.d"
/usr/bin/java -jar $YWC_HOME/ywc.core/ywc.java/ywc.backend.d/dist/ywc.backend.d.jar

echo "restarting memcached..."
service memcached restart
