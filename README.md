# docker-compose ci example

A simple python application with `docker-compose` integration tests that run inside a container so that in can be used in a continuous integration pipeline like concourse.

## Setup
`docker` and `docker-compose` are required.

## Overview
[`app.py`](app.py) is a simple counting web app built with [`Dockerfile.app`](Dockerfile.app) that uses redis for state.

[`itest.sh`](itest.sh) is an integration test script run from a [`Dockerfile.itest`](Dockerfile.itest) container that will exit 0 on success, 1 on error.

[`docker-compose.yaml`](docker-compose.yaml) starts up redis and the app containers.  It also starts the test container to run tests against the app.

[`run.sh`](run.sh) uses `docker-compose` to start everything up, report test status, and clean everything up.

[`Dockerfile.dcind`](Dockerfile.dcind) Is used to run `run.sh` inside a container.

[`pipeline.yaml`](pipeline.yaml) is a concourse pipeline that runs the integration tests using dcind.

## Usage
Run docker-compose integration tests locally:
```
./run.sh
```

Run docker-compose integration tests in docker:
```
docker build -t dcind -f Dockerfile.dcind . && docker run --rm -t --privileged dcind
```

## Concourse
Push a container from `Dockerfile.dcind`
```
docker build -f Dockerfile.dcind -t dj80hd/dcind .
docker push dj80hd/dcind .
```

Create and start a pipeline that runs it
```
fly -t sh sp -c pipeline.yaml -p dcind
fly -t sh up -p dcind
fly -t sh tj -j dcind/dcind -w
```
