#!/bin/bash
cd "$( cd "$( dirname "$0" )" && pwd )"
coffee -c keypress.coffee
java -jar compiler.jar --js keypress.js --js_output_file keypress-1.0.8.min.js
