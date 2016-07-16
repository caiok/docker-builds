#!/usr/bin/env bash

# --------------------------------------- #
USAGE="
$(basename "$0") [-h | container_name]

where:
    -h:             Show this help text
    container_name: Container name (default ${CONTAINER_NAME})
"

# Check whether the script was executed within its directory or not
if [[ $(dirname "$0") != $PWD ]]
then
	echo
	echo "The script must be run within its directory (cd to the script directory and then executes it with ./$(basename $0)"
	echo
	exit
fi

# Check if the script was invoked with -h
if [[ ("$1" == "-h" )  || ("$1" == "--help" ) ]]
then
	echo "$USAGE"
	exit
fi
# --------------------------------------- #

# --------------------------------------- #
# Set the workspace that should be exported to the docker container
WORKSPACE=$HOME/Desktop/workspace/

# Decide image name concatenating user_name + build_dir
IMAGE="${USER}/$(basename $(dirname $0)):latest"

# Check whether the container name was provided"
if [[ ( "$1" == "" ) ]]
then
	CONTAINER=$(basename $(dirname $0))
else
	CONTAINER=$1
fi

# Echo some infos
echo
echo -e "Image name: \e[1m${IMAGE}\e[0m"
echo -e "Container name: \e[1m${CONTAINER}\e[0m"
echo
# --------------------------------------- #

# --------------------------------------- #
# Echo if the image is already present
echo "> docker images {IMAGE}"
docker images {IMAGE}
image_ready="$(docker images debian:latest1 | grep -v REPOSITORY)"
echo

# If image is not present, build it
if [[ "${image_ready}" == "" ]]
then
	echo "Image not ready. Start building process..."
	echo
	echo "docker build -t ${IMAGE} ."
	docker build -t ${IMAGE} .
	build_result=$?
	echo
	if [[ ${build_result} != 0 ]]
	then
		echo "BUILD FAILED!!"
		echo
		exit
	fi
fi
# --------------------------------------- #

# --------------------------------------- #
# Echo if the container is already present
echo "> docker ps -a --filter \"name=${CONTAINER}\""
docker ps -a --filter "name=${CONTAINER}"
container_ready=$(docker ps -a --filter "name=${CONTAINER}" | grep -v 'CONTAINER ID')
echo

# If the container is not present, create it
if [[ ${container_ready} != 0 ]]
then
	docker run -i -t -d \
			   --name "${CONTAINER}" \
			   -e DISPLAY=$DISPLAY \
			   -v /tmp/.X11-unix:/tmp/.X11-unix \
			   -v ${WORKSPACE}:/workspace \
			   ${IMAGE}
fi
# --------------------------------------- #

# --------------------------------------- #
# Try to start the container (raise an error if not present)
echo "> docker start ${CONTAINER}"
docker start ${CONTAINER}
start_success=$?
echo

if [[ $start_success != 0 ]]
then
	echo "START FAILED!!"
	echo
	exit
fi
# --------------------------------------- #

# --------------------------------------- #
# Container IP Address
IP_ADDRESS=$(docker inspect ansible_1 | grep \"IPA | head -n1 | awk -F '"' '{ print $4 }')

# Echo some infos
echo
echo -e "Image name: \e[1m${IMAGE}\e[0m"
echo -e "Container name: \e[1m${CONTAINER}\e[0m"
echo -e "IP address: \e[1m${IP_ADDRESS}\e[0m"
echo
# --------------------------------------- #

# --------------------------------------- #
# At last execute a shell on the created container
docker exec -i -t 

# --------------------------------------- #
