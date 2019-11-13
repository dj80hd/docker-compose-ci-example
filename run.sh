#!/bin/bash

# Use docker-compose to run an itegration test

# ci systems (e.g. concourse) dump in you a tempdir
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# setup
docker-compose build
docker-compose up -d

# run integration test from test container
docker exec docker-compose-ci-example_itest_1 /itest.sh
retcode=$?

# clean up
docker-compose rm -v --force --stop

# return code to caller
echo "exit ${retcode}"
exit ${retcode}
