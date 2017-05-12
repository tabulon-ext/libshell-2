#!/bin/bash

SCRIPTNAME="$0"
SCRIPT=$(readlink -n "$SCRIPTNAME")

SCRIPTPATH=$(dirname "$SCRIPT")
ARGS="$@"
BRANCH="master"

self_update_git() {
    
    cd $SCRIPTPATH
    git fetch

    # [ $(git diff --name-only origin/$BRANCH | grep $SCRIPTNAME | wc -l | grep -Eo "\d+") -ne 0 ] && {
    [ $(git diff --name-only origin/$BRANCH | wc -l | grep -Eo "\d+") -ne 0 ] && {
        
        echo "Found a new version of me, updating myself..."
        
        git pull --force
        git checkout -f $BRANCH
        git pull --force

        echo "Running the new version..."
        exec "$SCRIPTNAME" "$ARGS"

        # Now exit this old instance
        exit 1
    }

    echo "Already the latest version."
}

self_update_http(){
    
    if [ $(wget --output-document=$SCRIPT.tmp $1/$SCRIPT) ]; then
        echo "error on wget on $SCRIPT update" 
        exit 1
    fi

    mv $SCRIPT.tmp $SCRIPT
}

self_update_test(){
    echo "Call: self_update_test $@";
}

main() {
   echo "Running..."
}

case "$1" in 
    git|http|test) 
        self_update_$ARGS
        main
    ;;
    * )
        echo "Invalid call!";
    ;;
esac
