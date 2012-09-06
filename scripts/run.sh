#!/bin/bash

DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

echo "Building project"
./build.sh

echo "Starting server"
cd ../serverto/build
nodemon app.js

exit 0
