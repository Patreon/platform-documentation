#!/usr/bin/env bash

#
# This shell script uploads server files to the server bucket on S3
#

set -e # exit this script if any command fails

BUCKET=docs.patreon.com
BUILD_DIR=build
REGION="${BUCKET_REGION:-us-west-1}"

#
# Files on master branch get double-posted to the root directory
#
if [[ "${CIRCLE_BRANCH}" == "master" ]]; then
    aws s3 cp \
        --region ${REGION} \
        --recursive \
        --metadata-directive REPLACE \
        --include "*" \
        ${BUILD_DIR} s3://${BUCKET}
else
    #
    # Files go under a branch-delimited directory
    #
    aws s3 cp \
        --region ${REGION} \
        --recursive \
        --metadata-directive REPLACE \
        --include "*" \
        ${BUILD_DIR} s3://${BUCKET}/beta/${CIRCLE_BRANCH}
fi
