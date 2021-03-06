#!/bin/bash

##########################################################################################
# Script to simplify git tagging of multiple repos for release
# Author: Tina Barfield https://github.com/tinabme
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

# check if stdout is a terminal...
if test -t 1; then
    # see if it supports colors...
    ncolors=$(tput colors)

    if test -n "$ncolors" && test $ncolors -ge 8; then
        bold="$(tput bold)"
        underline="$(tput smul)"
        standout="$(tput smso)"
        normal="$(tput sgr0)"
        black="$(tput setaf 0)"
        red="$(tput setaf 1)"
        green="$(tput setaf 2)"
        yellow="$(tput setaf 3)"
        blue="$(tput setaf 4)"
        magenta="$(tput setaf 5)"
        cyan="$(tput setaf 6)"
        white="$(tput setaf 7)"
    fi
fi

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
    echo $(tput setaf 7) ------------------------------------------------------------------------------------
    echo $(tput setaf 5) $(tput bold) "$var" $(tput sgr0)
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
      echo $(tput setaf 1) $(tput bold) "Something is wrong cant tag" $(tput sgr0)
    else
      git tag --sort=-version:refname | head -n 10 #list last 10 git tags
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
  echo $(tput setaf 1) $(tput bold) "Usage: script name, each repo separated by space, tag" $(tput sgr0)
  echo $(tput setaf 1) $(tput bold) "example: ./gitTagMaster.sh mySiteUI_js mySiteLambda mySiteCLI v2.1.3" $(tput sgr0)
fi
