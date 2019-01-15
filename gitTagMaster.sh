#!/bin/bash

##########################################################################################
# Script to simplify git tagging of multiple repos for release
#
#
# Usage: script name then each repo separated by space then tag 
# Notes: 
#     - You may want to run the first time with #git tag $TAG & #git push --tags commented out
#       then when you have all of the proper repos uncomment and run for real
#     - You can use default hardcoded repos or pass repos as arguments
# 
# Examples:
#  From parent directory in which each of the repo directories live
#  - with repo arguments: ./gitTagMaster.sh mySiteUI_js mySiteLambda mySiteEngine_ruby mySiteCLI v2.1.3
#  - without repo arguments: ./gitTagMaster.sh v2.1.3
##########################################################################################


# verify that the tag argument is passed and the last argument starts with a v
if [[ $# -gt 0 ]] && [[ ${!#} == v* ]]; then

  # default hardcoded repos, or passed repo arguments
  if [ $# -eq 1 ]; then
    REPOS="mySiteUI_js
  mySiteLambda"
  else
    REPOS="$@" #all arguments
  fi

  TAG="${!#}"   # The tag is the last argument


  # For each repo, stash uncommitted changes, checkout the 'master' branch, pull, tag & push tag 
  # then checkout 'dev' branch and stash pop
  for var in $REPOS 
  do
    if [ $var = $TAG ]; then
      break
    fi
    STASHED=0
    echo    
    echo ------------------------------------------------------------------------------------
    echo "$var" 
    cd "$var"
    
    #check to see if there are any changes and stash if needed
    if [[ `git status --porcelain` ]]; then
      STASHED=1
      git stash
    fi

    # pull master repo
    git checkout master
    git pull

    # check to see if the pull was clean
    if [[ `git status --porcelain` ]]; then
      echo "Something is wrong cant tag" $(tput sgr0)
    else
      git tag
      echo "tag $TAG"
      git tag $TAG    # may want to do a test run with this commented out
      git push --tags # may want to do a test run with this commented out
    fi

    # return repo back to dev
    git checkout dev
    git pull

    if [ "$STASHED" = 1 ]; then
      STASHED=0
      git stash pop
    fi

    # move back to parent directory
    cd ..
  done

else
  echo "Usage: script name, each repo separated by space, tag"
  echo "example: ./gitTagMaster.sh mySiteUI_js mySiteLambda mySiteCLI v2.1.3"
fi