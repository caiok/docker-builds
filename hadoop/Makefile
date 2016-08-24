# Inspired by https://github.com/HariSekhon/Dockerfiles

REPO=caiok/hadoop

TAG=$(shell perl -n -e '/^\s*ARG\s+.+_VERSION\s*=\s*(\d+\.\d+)/ && &{ print $$1; exit }' Dockerfile)

.PHONY: all
all:
	make build

.PHONY: build
build:
	docker build -t $(REPO):$(TAG) .

.PHONY: nocache
nocache:
	docker build -t $(REPO):$(TAG) --no-cache .

.PHONY: run
run:
	docker run -ti -p 8020:8020 -p 8032:8032 -p 8088:8088 -p 9000:9000 -p 10020:10020 -p 19888:19888 -p 50010:50010 -p 50020:50020 -p 50070:50070 -p 50075:50075 -p 50090:50090 $(REPO):$(TAG)
Contact GitHub API Training Shop Blog About
© 2016 GitHub, Inc. Terms Privacy Security Status Help