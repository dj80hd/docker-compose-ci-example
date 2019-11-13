# docker-compose ci example

Simple python application to exercise using `docker-compose` as an intergration testing tool in a ci (continuous integration) system.

## Setup
`docker` and `docker-compose` are required.

## Overview
[`app.py`](app.py) is a simple counting web app built with [`Dockerfile.app`](Dockerfile.app) that uses redis for state.

[`itest.sh`](itest.sh) is an integration test script added to containers built with [`Dockerfile.test`](Dockerfile.itest) that will exit 0 on success, 1 on error.

[`docker-compose.yaml`](docker-compose.yaml) starts the app container along with the redis container upon which it depends.  It also starts the test container to run tests against the app.

[`run.sh`](run.sh) uses `docker-compose` to start everything up, report test status, and clean everything up.

[`Dockerfile.dcind`] creates a docker-compose-in-docker container that runs `run.sh`

## Usage
Run the test locally:
```
./run.sh
```

Run it in a container:
```
docker build -t dcind -f Dockerfile.dcind . && docker run --rm -t --privileged dcind
```

