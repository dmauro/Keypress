#!/bin/bash
cd "$( cd "$( dirname "$0" )" && pwd )"
cd ..
coffee -o . -cb ./keypress.coffee
coffee -c test/tests.coffee
open test/run_tests.html
