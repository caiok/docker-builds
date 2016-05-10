# Django

## Current Version

Django: 1.9
Python: 3.4
MySQL:  5.6

### Build

```
cd django
docker build --build-arg [HTTP_PROXY=http://proxy.mmfg.it:8080] -t <project>:latest .
```

### Run

```
docker run -i -t -d <project>:latest
```