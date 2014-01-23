#!/bin/bash

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
cd $DIR/../..;
export YWC_HOME=`pwd`;

# running backend.d
/usr/bin/java -jar ywc.core/ywc.java/ywc.backend.d/dist/ywc.backend.d.jar "xml_generate";
/usr/bin/java -jar ywc.core/ywc.java/ywc.backend.d/dist/ywc.backend.d.jar "uri_cache";
