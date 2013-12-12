#!/bin/bash

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
cd $DIR/../..;
export YWC_HOME=`pwd`;

# running backend.d
java -jar ywc.core/ywc.java/ywc.backend.d/dist/ywc.backend.d.jar;
