#!/bin/bash
cd "$( cd "$( dirname "$0" )" && pwd )"
coffee -o . -cb ../keypress.coffee
coffee -c tests.coffee
open run_tests.html
