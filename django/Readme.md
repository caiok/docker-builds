# Django Docker

Personalized version of django docker image. 

## Current Version

- Docker Image: django:1.9-python3
- Django: 1.9
- Python: 3.4
- MySQL:  5.6

### Build

```
cd django
docker build --build-arg [HTTP_PROXY=http://proxy.mmfg.it:8080] -t caio/django:mysql .
```

### Run

```
docker run -i -t -d --name "<project>_container" [-p 80:80 -p 3306:3306 | -P] [-v <workspace>:/repo] caio/django:mysql
docker exec -i -t <project>_container /bin/bash -l
```

### Examples

```
docker build --build-arg HTTP_PROXY=http://proxy.mmfg.it:8080 -t caio/django:mysql .
docker run -i -t -d --name "django_poll" -p 80:80 -p 3306:3306 -v /Users/francescocaliumi/devel:/repo caio/django:mysql
docker exec -it django_poll /bin/bash -l
```