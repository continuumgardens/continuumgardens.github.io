#!/bin/bash

DIR=$1

pushd $DIR > /dev/null 2> /dev/null

DEST=$(jekyll build 2> /dev/null | fgrep 'Destination:' | cut -d':' -f 2)
python -c "import os,sys; print os.path.realpath(sys.argv[1])" $DEST

popd > /dev/null 2> /dev/null
