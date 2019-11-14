# docker-compose ci example

A simple python application with `docker-compose` integration tests that run inside a container so that in can be used in a continuous integration pipeline like concourse.

## Background

Concourse [does not support docker-compose well](https://github.com/concourse/concourse/issues/324).  

[`dcind`](https://github.com/meAmidos/dcind) is one of the work-arounds and the basis of this example.

## Setup
`docker` and `docker-compose` are required.

## Overview
[`app.py`](app.py) is a simple counting web app built with [`Dockerfile.app`](Dockerfile.app) that uses redis for state.

[`itest.sh`](itest.sh) is an integration test script run inside a container built from [`Dockerfile.itest`](Dockerfile.itest).
o

[`docker-compose.yaml`](docker-compose.yaml) contains configuration to start up the app, redis, and integration test containers.

[`run.sh`](run.sh) uses this configuration and `docker-compose` to start everything up, run integration tests, report test status, and clean everything up.

[`pipeline.yaml`](pipeline.yaml) is a concourse pipeline that executes [`run.sh`](run.sh) inside of a container built with [`Dockerfile.dcind`](Dockerfile.dcind).

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

Create, start, and watch a pipeline that runs it
```
export FLY_TARGET=whatever
fly -t ${FLY_TARGET} sp -c pipeline.yaml -p dcind
fly -t ${FLY_TARGET} up -p dcind
fly -t ${FLY_TARGET} tj -j dcind/dcind -w
```
