#!/bin/bash -e
# (run with 'exit-on-error')

SCRIPT_NAME=$(basename "$0")
echo "--- -----------------------------------------------------------------------------------------"
echo "-S- ${SCRIPT_NAME}: Save changes to Jenkins-git repository"
echo "--- -----------------------------------------------------------------------------------------"

# Set default values for parameters, case they are empty or undefined
: "${VERBOSE:=false}"

if [[ -e "$GIT_TOOL" ]]
then
  GIT_VERSION=$($GIT_TOOL --version)
  echo "-I- Using git '$GIT_TOOL'"
  echo "-I-       $GIT_VERSION"
else
  echo "-E- \$GIT_TOOL not found ('$GIT_TOOL') - Exiting"
  exit 9
fi

if [[ -z $JENKINS_HOME ]]
then
  echo "-E- \$JENKINS_HOME is not defined - Exiting"
  exit 8
elif [[ -d $JENKINS_HOME ]]
then
  echo "-I-"
  echo "-I- Switching to the Jenkins-Home dir ('$JENKINS_HOME')"
else
  echo "-E- \$JENKINS_HOME not found ('$JENKINS_HOME') - Exiting"
  exit 7
fi

cd "$JENKINS_HOME"

if [[ ${VERBOSE} != false ]]
then
  echo "-- ENV ------------------------------------------------------------------"
  env | sort
  echo "-- ENV ------------------------------------------------------------------"

  # Activate command-echo
  set -x
fi

echo "-I-"
echo "-I- Make sure we are up-to-date with remote repo"
$GIT_TOOL fetch
$GIT_TOOL status
$GIT_TOOL stash list
GIT_STASH_RESULT=$($GIT_TOOL stash)
$GIT_TOOL pull --rebase

if [[ $GIT_STASH_RESULT == "No local changes to save" ]]
then
  echo "    (nothing to pop)"
else
  $GIT_TOOL stash pop
fi

echo "-I-"
echo "-I- check if there are any local changes"

if git diff-index --quiet HEAD --
then
  echo "-I- No local changes found - exiting"
  echo "-S- ${SCRIPT_NAME} - Done (nothing)"
  exit 0
else
  echo "-I- (found some local changes - continuing)"
fi

echo "-I-"
echo "-I- Save the main configuration-file"
$GIT_TOOL add config.xml
echo "-I-"
echo "-I- Save any other configuration-file"
find jobs -name "config.xml"  -exec "$GIT_TOOL" add {} \;
echo "-I-"
echo "-I- Save agent-configuration files (nodes)"
find nodes -name "config.xml"  -exec "$GIT_TOOL" add {} \;
echo "-I-"
echo "-I- Get rid of any files that were deleted"
FILES_TO_DELETE=$($GIT_TOOL ls-files --deleted | wc -l)
if [[ $FILES_TO_DELETE -gt 0 ]]
then
  $GIT_TOOL ls-files --deleted -z | xargs -0 "$GIT_TOOL" rm --
fi
echo "-I-"
echo "-I- Commit your work to the Jenkins repository"
$GIT_TOOL commit -m "${SCRIPT_NAME}: Save any changes made to jobs or agents"
echo "-I-"
echo "-I- Commit content:"
echo "-I- -----------------------------------------------------------------------------"
$GIT_TOOL show --name-status --oneline
echo "-I- -----------------------------------------------------------------------------"
echo "-I-"
echo "-I- Push changes to the remote repo."
$GIT_TOOL push
echo "-I-"
echo "-S- ${SCRIPT_NAME} - Done"

exit 0
