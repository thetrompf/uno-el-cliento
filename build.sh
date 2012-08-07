echo "Copying static client files..."
php build.php

echo "Compiling less files..."
if [ ! -d "public/css" ]; then
	mkdir public/css
fi
lessc cliento/less/app.less public/css/app.css

echo "Compiling client coffee..."
coffee -c -b -o public/js/ cliento/coffee/

echo "Compiling server coffee..."
coffee -c server.coffee