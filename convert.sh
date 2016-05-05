#!/bin/bash

DIST_FILE=$1

echo "Converting $DIST_FILE"

# Base Engine darcs reference
FROM_ENGINE="darcs / http://openengine.dk/code/openengine"
TO_ENGINE="git / https://github.com/OpenEngineDK/openengine.git"
sed -i "s#$FROM_ENGINE#$TO_ENGINE#g" $DIST_FILE

FROM_ENGINE_DEV="darcs-dev / fh.daimi.au.dk:/users/cgd/code/openengine"
TO_ENGINE_DEV="git-dev / git@github.com:OpenEngineDK/openengine.git"
sed -i "s#$FROM_ENGINE_DEV#$TO_ENGINE_DEV#g" $DIST_FILE

# Other darcs reference
FROM_DARCS="darcs \(.*\) http://openengine.dk/code/\(.*\)/\(.*)"
TO_DARCS="git \1 https://github.com/OpenEngineDK-\2-\3.git"
sed -i "s#$FROM_DARCS#$TO_DARCS#g" $DIST_FILE.git

FROM_DARCS_DEV="darcs-dev \(.*\) fh.daimi.au.dk:/users/cgd/code/\(.*\)/\(.*\)"
TO_DARCS_DEV="git-dev \1 git@github.com:OpenEngineDK-\2-\3.git"
sed -i "s#$FROM_DARCS_DEV#$TO_DARCS_DEV#g" $DIST_FILE.git

# Dist references
FROM_DIST="http://openengine.dk/code/\(.*\)/\(.*\)/\(.*\).dist"
FROM_DIST="http://www.openengine.dk/code/\(.*\)/\(.*\)/\(.*\).dist"
TO_DIST="https://raw.githubusercontent.com/OpenEngineDK/\1-\2/master/\3.dist"

sed -i "s#$FROM_DIST#$TO_DIST#g" $DIST_FILE
sed -i "s#$FROM_DIST_2#$TO_DIST#g" $DIST_FILE
