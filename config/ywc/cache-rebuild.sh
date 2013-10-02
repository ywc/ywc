#!/bin/bash

export SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
cd $SCRIPT_DIR/../..;
export YWC_HOME=`pwd`;
cd $YWC_HOME;

export YWC_APP=`cat config/app_name`;

java -jar ywc.core/ywc.java/ywc.backend.d/dist/ywc.backend.d.jar