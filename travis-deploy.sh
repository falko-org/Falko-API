#!/bin/sh
# Pushing updated scripts only if its devel branch 

if [[ "$TRAVIS_BRANCH" != "devel" ]]; then
  echo "We're not on the devel branch."  
else 
  echo "YAY!!! We're  able to deploy."
fi

exit 0
