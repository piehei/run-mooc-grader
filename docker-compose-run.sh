#!/bin/bash
# Orders a container using docker run command.
# The container command is responsible to

SID=$1
GRADER_HOST=$2
DOCKER_IMAGE=$3
EXERCISE_MOUNT=$4
SUBMISSION_MOUNT=$5
CMD=$6

# Manage for docker-compose setup, see test course for reference.
# Docker cannot bind volume from inside docker so global /tmp is used.
TMP=/tmp/aplus
TMP_EXERCISE_MOUNT=$TMP/_ex/${EXERCISE_MOUNT##/srv/courses/}
TMP_SUBMISSION_MOUNT=$TMP/${SUBMISSION_MOUNT##/srv/uploads/}
rm -rf $TMP_EXERCISE_MOUNT
mkdir -p $TMP_EXERCISE_MOUNT
mkdir -p $TMP_SUBMISSION_MOUNT
cp -r $EXERCISE_MOUNT $(dirname $TMP_EXERCISE_MOUNT)
cp -r $SUBMISSION_MOUNT $(dirname $TMP_SUBMISSION_MOUNT)

docker run \
  -d --rm \
  -e "SID=$SID" \
  -e "REC=$GRADER_HOST" \
  -v $TMP_EXERCISE_MOUNT:/exercise \
  -v $TMP_SUBMISSION_MOUNT:/submission \
  --network=aplus_default \
  $DOCKER_IMAGE \
  $CMD
