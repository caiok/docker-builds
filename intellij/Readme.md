# Django Docker

Docker image for install oracle java sdk and IntelliJ IDE.

Important: remember to add the public keys you want to authorize in authorized_keys before building up the image

## Current Version

- Docker Image: ubuntu:latest

### Build

```
cd ansible
docker build --build-arg [HTTP_PROXY=http://proxy.mmfg.it:8080] -t caio/ansible .
```

### Run

```
docker run -i -t -d --name "<project>_container" [-p 80:80 -p 3306:3306 | -P] [-v <workspace>:/repo] caio/ansible
docker exec -i -t <project>_container /bin/bash -l
```

### Examples

```
docker build --build-arg HTTP_PROXY=http://proxy.mmfg.it:8080 -t caio/ansible .
docker run -i -t -d --name "ansible_x" caio/ansible
docker exec -i -t ansible_x /bin/bash -l
```
