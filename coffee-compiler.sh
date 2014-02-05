#!/bin/bash
VERSION="2.0.1"
YEAR="2014"
cd "$( cd "$( dirname "$0" )" && pwd )"
coffee -c keypress.coffee
java -jar compiler.jar --js keypress.js --js_output_file keypress-$VERSION.min.js
printf "/*\n  Keypress version ${VERSION} (c) ${YEAR} David Mauro.\n  Licensed under the Apache License, Version 2.0\n  http://www.apache.org/licenses/LICENSE-2.0\n*/\n"|cat - keypress-$VERSION.min.js > /tmp/out && mv /tmp/out keypress-$VERSION.min.js
