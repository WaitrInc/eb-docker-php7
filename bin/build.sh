#!/bin/bash

# first, be sure that an environment file exists
[ -f .env ] || {
    "An environment file [.env], with variables [AWS_ACCOUNT_ID] is required"
    exit 1
}

# source the environment file
. .env

# Iterate over required binaries, to ensure the system has all the requirements
for req in docker git; do
    [ ! -z "$(which "${req}")" ] || {
        echo "The required binary [${req}] was not found"
        exit 1
    }
done

# Sanity checks passed. Do the work
GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"

docker build --no-cache -t "php7:${GIT_BRANCH}" .
