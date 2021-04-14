#!/bin/bash

# first, be sure that an environment file exists
[ -f .env ] || {
    "An environment file [.env], with variables [AWS_ACCOUNT_ID] is required"
    exit 1
}

# source the environment file
. .env

# Iterate over required variables, and ensure that they are set.
for req in AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_ACCOUNT_ID; do
  [ ! -z "${!req}" ] || {
      echo "The required variable [${req}] is empty"
      exit 1
  }
done

# Iterate over required binaries, to ensure the system has all the requirements
for req in aws docker git; do
    [ ! -z "$(which "${req}")" ] || {
        echo "The required binary [${req}] was not found"
        exit 1
    }
done

# Sanity checks passed. Do the work
GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin "${AWS_ACCOUNT_ID}.dkr.ecr.us-west-2.amazonaws.com"
docker tag "php7:${GIT_BRANCH}" "${AWS_ACCOUNT_ID}.dkr.ecr.us-west-2.amazonaws.com/php7:${GIT_BRANCH}"
docker push "${AWS_ACCOUNT_ID}.dkr.ecr.us-west-2.amazonaws.com/php7:${GIT_BRANCH}"
