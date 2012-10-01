#!/bin/bash
DS=$1                                   # / or \\

BASE=$2                                 # D:\workspace\coffee
INPUTFILE=$3                            # D:\workspace\coffee\client\scripts\app\bootstrap.coffee
FILENAME=${INPUTFILE##*"$DS"}           # bootstrap.coffee
FILEEXT=${FILENAME##*.}                 # coffee
INPUTDIR=${INPUTFILE%%"$DS$FILENAME"}   # D:\workspace\coffee\client\scripts\app

RELATIVE=${INPUTFILE:${#BASE}+1}        # client\scripts\app\bootstrap.coffee
MODE=${RELATIVE%%"$DS"*}                # client

# echo $@
# echo "DS:             $DS"
# echo "BASE:           $BASE"
# echo "INPUTFILE:      $INPUTFILE"
# echo "FILENAME:       $FILENAME"
# echo "FILEEXT:        $FILEEXT"
# echo "INPUTDIR:       $INPUTDIR"
# echo "RELATIVE:       $RELATIVE"
# echo "MODE:           $MODE"

case $MODE in
	serverto)

		MODESERVER="${MODE}${DS}source"
		BUILDDIR="${BASE}${DS}${MODE}${DS}build"
		OUTPUTRELATIVE=${INPUTFILE:${#BASE}+${#DS}+${#MODESERVER}+1}
		OUTPUTDIR=$BUILDDIR$DS${OUTPUTRELATIVE%"$FILENAME"}
		OUTPUTDIR=${OUTPUTDIR%"$DS"}
		UNIXPATH=${OUTPUTDIR//\\/\/}
		UNIXPATH=${UNIXPATH/:/''}

		echo "Server"

		echo "INPUTFILE:      $INPUTFILE"
		# echo "BUILDDIR:       $BUILDDIR"
		# echo "OUTPUTRELATIVE: $OUTPUTRELATIVE"
		echo "OUTPUTDIR:      $OUTPUTDIR"

		mkdir -p "/$UNIXPATH"

		case $FILEEXT in
			coffee) echo "Compiling coffee file"
				coffee -b -c -o $OUTPUTDIR $INPUTFILE
				;;
			js) echo "Copying js file"
				cp "$INPUTFILE" "$OUTPUTDIR$DS$FILENAME"
				;;
		esac
		;;
	cliento)

		OUTPUTFILE="${BASE}${DS}public${RELATIVE:${#MODE}}"
		OUTPUTDIR=${OUTPUTFILE%"$DS$FILENAME"}
		UNIXPATH=${OUTPUTDIR//\\/\/}
		UNIXPATH=${UNIXPATH/:/''}

		LESSINPUT="${BASE}${DS}${MODE}${DS}styles${DS}style.less"
		LESSOUTPUT="${BASE}${DS}public${DS}styles${DS}style.css"

		echo "Client"

		echo "INPUTFILE:      $INPUTFILE"
		echo "OUTPUTDIR:      $OUTPUTDIR"
		# echo "OUTPUTFILE:     $OUTPUTFILE"
		# echo "LESSINPUT:      $LESSINPUT"
		# echo "LESSOUTPUT:     $LESSOUTPUT"


		mkdir -p "/$UNIXPATH"

		case $FILEEXT in
			coffee) echo "Compiling $FILEEXT file"
				coffee -b -c -o $OUTPUTDIR $INPUTFILE
				;;
			less) echo "Compiling $FILEEXT file"
				lessc "$LESSINPUT" "$LESSOUTPUT"
				;;
			css) echo "Copying $FILEEXT and compiling less file"
				lessc "$LESSINPUT" "$LESSOUTPUT"
				cp "$INPUTFILE" "$OUTPUTFILE"
				;;
			hbs|tmpl|html|jshtml) echo "Copying $FILEEXT file"
				cp "$INPUTFILE" "$OUTPUTFILE"
				;;
			js) echo "Copying js file"
				cp "$INPUTFILE" "$OUTPUTFILE"
				;;
			*)
				echo "Unsupported file extension: $INPUTFILEEXT in $INPUTFILE"
				exit 1
			;;
		esac
		;;
	scripts)
		exit 0
		;;
	*)
		echo "Mode: $MODE isn't supported!"
		exit 1
		;;
esac
exit 0
