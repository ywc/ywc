#!/bin/bash

export SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
cd $SCRIPT_DIR/../..;
export YWC_HOME=`pwd`;
cd $YWC_HOME;

export YWC_APP=`cat config/app_name`;

# update ywc core
git pull;

# run app specific update script
if [ -f config/$YWC_APP/update.sh ]; then
  # config/$YWC_APP/update.sh;
  echo "it's there";
fi

#config/ywc/database-rebuild.sh
