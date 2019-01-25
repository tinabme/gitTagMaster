# gitTagMaster

gitTagMaster is a script to simplify git tagging of multiple repos for release.

### How To Use

  - Download the script to the folder that holds all of the repos to be tagged
  - Run the script by providing the script name then each repo separated by space then tag
  `$ ./gitTagMaster.sh mySiteUI_js myStLambda myStEng_ruby mySiteCLI v2.1.3`
in the above example three repos (mySiteUI_js, myStLambda & myStEng_ruby) are being tagged with the tag v2.1.3
 - You can also set default repos to be tagged when left out of the command
 `./gitTagMaster.sh v2.1.3`
in this case the default repos will be tagged with v2.1.3

### Notes
- By default uncommitted changes are stashed, the 'master' branch is checked out and pulled, then it is tagged & and the tag is pushed.  _You can change the branch._
- Then the 'dev' branch is checked out and stash pop is run only on the repos that had uncommitted changes.  _You can change the branch, or comment this out completely_
- You may want to run the first time with #git tag $TAG & #git push --tags commented out then when you have all of the proper repos in the folder, uncomment and run for real
