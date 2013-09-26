#!/bin/bash

export SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
cd $SCRIPT_DIR/../..;
export YWC_HOME=`pwd`;
cd $YWC_HOME;

if [ ! -d cache ]; then
  mkdir cache cache/doc cache/tmp cache/txt cache/xml cache/doc/orig cache/doc/temp cache/doc/thmb cache/doc/work cache/tmp/gen cache/tmp/img cache/tmp/ing cache/tmp/txt cache/tmp/upl cache/tmp/xml cache/xml/cache cache/xml/data;
  cat config/ywc/templates/data-default.xml | tee cache/xml/data/cache.xml cache/xml/data/include.xml cache/xml/data/placeholder.xml cache/xml/data/scope.xml cache/xml/data/template.xml cache/xml/data/transform.xml cache/xml/data/uri.xml cache/xml/data/user.xml > /dev/null;
fi
chmod -Rf a+rw cache;

# cd $YWC_HOME/config/;
# ./update_code.sh;
# ./update_cache.sh;
