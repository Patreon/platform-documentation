#!/usr/bin/env bash
set -e # exit this script if any command fails

BUCKET=docs.patreon.com
BUILD_DIR=build

#
# This shell script uploads server files to the server bucket on S3
#


#
# Files go under a branch-delimited directory
#
aws s3 cp \
    --recursive \
    --metadata-directive REPLACE \
    --include "*" \
    $BUILD_DIR s3://$BUCKET/beta/$CIRCLE_BRANCH

#
# Files on master branch get double-posted to the root directory
#
if [[ $CIRCLEBRANCH -eq "master" ]]; then
    aws s3 cp \
        --recursive \
        --metadata-directive REPLACE \
        --include "*" \
        $BUILD_DIR s3://$BUCKET
fi