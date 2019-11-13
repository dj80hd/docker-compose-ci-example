#!/bin/sh

# make 2 requests to app to test correct counts
URL='http://web:5000'

COUNT1=$(curl -s ${URL})
COUNT2=$(curl -s ${URL})

[[ "${COUNT1}" != "1" ]] && { echo "FAIL!"; exit 1; }
[[ "${COUNT2}" != "2" ]] && { echo "FAIL!"; exit 1; }

echo "SUCCESS!"
