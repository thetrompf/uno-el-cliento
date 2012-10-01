#!/bin/bash

DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

echo "Copying static files"
php phake.php nuke
php phake.php bake

echo "Building client"
coffee -b -c -o ../public/scripts ../cliento/scripts
mkdir -p ../public/styles
lessc ../cliento/styles/style.less > ../public/styles/style.css

echo "Building server"
coffee -b -c -o ../serverto/build ../serverto/source

echo "Done!"
exit 0
