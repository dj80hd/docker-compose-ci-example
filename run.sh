#/bin/bash

# Use docker-compose to run an itegration test

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
