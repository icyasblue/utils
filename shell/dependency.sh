#!/bin/bash
# to find all the dependencies for your node project
# usage dependency.sh PATH/TO/YOUR/NODE/PROJECT, default to current project

dir="."
if [ -z "$1" ]
    then dir="$1"
fi
find $dir ! -path "*/node_modules/*" -name "*.js" | xargs sed -n "s/.*require('\(.*\)'.*/\1/p" | grep -v '.js$' | sort | uniq -u
