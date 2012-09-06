#!/bin/bash

DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

echo "Installing Coffee Script compiler"
npm install -g coffee-script

echo "Installing LESS compiler"
npm install -g less

echo "Installing ExpressJS"
npm install -g express

echo "Installing NodeMon"
npm install -g nodemon

echo "Installing dependencies to the server"
cd ../server/build
npm install

cd ../..
scripts/run.sh

echo "Done!"