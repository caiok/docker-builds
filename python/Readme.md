# Django Docker

Personalized version of simple python:3.4 docker image. 

## Current Version

- Docker Image: python:3.4
- Python: 3.4

### Build

```
cd python
docker build --build-arg [HTTP_PROXY=http://proxy.mmfg.it:8080] -t caio/python:3.4 .
```

### Run

```
docker run -i -t -d --name "<project>_container" [-p 80:80 -p 3306:3306 | -P] [-v <workspace>:/repo] caio/python:3.4
docker exec -i -t <project>_container /bin/bash -l
```

### Examples

```
docker build --build-arg HTTP_PROXY=http://proxy.mmfg.it:8080 -t caio/python:3.4 .
docker run -i -t -d --name "cronls_container" -v /Users/francescocaliumi/devel:/repo caio/python:3.4
docker exec -i -t cronls_container /bin/bash -l
```