# Inspired by https://github.com/HariSekhon/Dockerfiles

REPO=caiok/hadoop
CONTAINER_NAME=hadoop

TAG=$(shell egrep '^\s*ARG\s+HADOOP_VERSION\s*=\s*(.+)\s*$$' Dockerfile | sed -r 's|\s*ARG\s+HADOOP_VERSION\s*=\s*(.+)\s*|\1|')

.PHONY: all build rebuild nocache run exec start stop shell

all:
	make exec

.builded:
	touch .builded

build: .builded
	docker build -t $(REPO):$(TAG) .
	
rebuild:
	rm .builded
	make build

nocache:
	docker build -t $(REPO):$(TAG) --no-cache .

run:
	#docker run -ti -p 8020:8020 -p 8032:8032 -p 8088:8088 -p 9000:9000 -p 10020:10020 -p 19888:19888 -p 50010:50010 -p 50020:50020 -p 50070:50070 -p 50075:50075 -p 50090:50090 $(REPO):$(TAG)
	docker run -it -d --name "$(CONTAINER_NAME)" $(REPO):$(TAG)

start:
	docker start "$(CONTAINER_NAME)"

stop:
	docker stop "$(CONTAINER_NAME)"

shell:
	docker exec -it "$(CONTAINER_NAME)" /bin/bash -l
