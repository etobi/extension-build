#!/bin/bash

if [ -n "$TRAVIS_TAG" ] && [ -n "$TYPO3_ORG_USERNAME" ] && [ -n "$TYPO3_ORG_PASSWORD" ]; then
	echo "Preparing upload of release ${TRAVIS_TAG} to TER"
	curl -sSL https://raw.githubusercontent.com/alrra/travis-after-all/1.4.4/lib/travis-after-all.js | node
	if [ $? -eq 0 ]; then
  		# Cleanup before we upload
  		git reset --hard HEAD && git clean -fx
  		TAG_MESSAGE=`git tag -n10 -l $TRAVIS_TAG | sed "s/^[0-9.]*[ ]*//g"`
  		echo "Uploading release ${TRAVIS_TAG} to TER (${TAG_MESSAGE})"
  		.Build/bin/upload . "$TYPO3_ORG_USERNAME" "$TYPO3_ORG_PASSWORD" "$TAG_MESSAGE"
  		if [ $? -eq 0 ]; then
    			exit 0;
  		else
    			echo "Error while uploading to TER"
    			exit 1;
  		fi;
	fi;
fi;

