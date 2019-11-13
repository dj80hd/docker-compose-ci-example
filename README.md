# docker-compose ci example

A simple python application with `docker-compose` integration tests that run inside a container so that in can be used in a continuous integration pipeline like concourse.

## Setup
`docker` and `docker-compose` are required.

## Overview
[`app.py`](app.py) is a simple counting web app built with [`Dockerfile.app`](Dockerfile.app) that uses redis for state.

[`itest.sh`](itest.sh) is an integration test script added to containers built with [`Dockerfile.test`](Dockerfile.itest) that will exit 0 on success, 1 on error.

[`docker-compose.yaml`](docker-compose.yaml) starts the app container along with the redis container upon which it depends.  It also starts the test container to run tests against the app.

[`run.sh`](run.sh) uses `docker-compose` to start everything up, report test status, and clean everything up.

[`Dockerfile.dcind`] creates a docker-compose-in-docker container that runs `run.sh`

## Usage
Run docker-compose integration tests locally:
```
./run.sh
```

Run docker-compose integration tests in docker:
```
docker build -t dcind -f Dockerfile.dcind . && docker run --rm -t --privileged dcind
```

