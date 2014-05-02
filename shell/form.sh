#!/bin/bash

# how to kill white spaces
# usage: ./form.sh your project's diretory
# example: ./form.sh ~/workspace/steak
# or: ./form.sh ~/workspace/steak/lighter
# REMINDER: add all the untracked files before running the script

function die() {
    echo $1
    exit 1
}

function find_git(){
    last_dir=' '
    while [ $(pwd) != "$last_dir" ]
    do
        pwd
        if [ $(ls -A | grep -c "^.git$") -ge 1 ]
        then
            return 0
        fi
        last_dir=$(pwd)
        cd ..
    done
    return 1
}


echo "cd $1 ..."
cd $1 2>&1 || die "ERROR: Can not cd!"
echo "checking ..."
find_git || die "ERROR: Not a git repository!"
git status > /dev/null 2>&1|| die "ERROR: Not a git repository!"
tmp=$(git diff HEAD~1..HEAD --check | grep -v + | cut -d : -f 1)
# tmp=$(git diff --check | grep -v + | cut -d : -f 1)
count=0
xx=" "
for x in $tmp
do
    if [ "$x" == "$xx" ]
    then
        continue
    fi

    echo "Modifying $x ..."
    # removing leading blank line
    sed -i '/./,$!d' $x
    # removing trailing white space
    sed -i -e 's/ *$//' $x
    # removing trailing blank line
    sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' $x
    # replace tab with 4 spaces
    # WARNING: it may ruining your indentation, comment out if necessary
    sed -i -e 's/\t/    /g' $x
    xx=$x
    let count++
done

if [ $count -eq 0 ]
then
    echo "Well formed already."
else
    echo "$count files changed, amend your commit."
fi
