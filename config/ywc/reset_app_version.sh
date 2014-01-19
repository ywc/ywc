#!/bin/bash

export SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
cd $SCRIPT_DIR/../..;

# generate "big" random number
export RAND=$RANDOM;
for (( b=0; b<32000; b++ ))
do
  export RAND=$(( RAND+$RANDOM ));
done

# turns random number into 10 character hash
export APP_VERSION=`echo -n $RAND | md5 | cut -c 1-10`;

# saves hash to local file
echo $APP_VERSION > config/app_version;