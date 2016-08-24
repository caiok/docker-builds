#!/usr/bin/env bash

# --------------------------------------- #
# Initial checks
# --------------------------------------- #
USAGE="
$(basename "$0") [-h | container_name]

where:
    -h:             Show this help text
    container_name: Container name (default ${CONTAINER_NAME})
"

SCRIPT_DIR=$(dirname "$(readlink -f $0)")

# Check whether the script was executed within its directory or not
if [[ ${SCRIPT_DIR} != $(pwd) ]]
then
	echo
	echo "The script must be run within its directory (cd to the script directory and then executes it with ./$(basename $0))"
	echo "( ${SCRIPT_DIR} != $(pwd) )"
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
# Configurations
# --------------------------------------- #
# Set the workspace that should be exported to the docker container
WORKSPACE=$HOME/Desktop/workspace/

# Decide image name concatenating user_name + build_dir
IMAGE="${USER}/$(basename ${SCRIPT_DIR}):latest"

# Check whether the container name was provided"
if [[ ( "$1" == "" ) ]]
then
	CONTAINER=$(basename ${SCRIPT_DIR})
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
# Build (if necessary)
# --------------------------------------- #
# Echo if the image is already present
echo "> docker images ${IMAGE}"
docker images ${IMAGE}
image_ready="$(docker images ${IMAGE} | grep -v REPOSITORY)"
echo

# If image is not present, build it
if [[ "${image_ready}" == "" ]]
then
	echo "Image not ready. Start building process..."
	echo
	exit
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
# Container creation (if necessary)
# --------------------------------------- #
# Echo if the container is already present
echo "> docker ps -a --filter \"name=${CONTAINER}\""
docker ps -a --filter "name=${CONTAINER}"
container_ready=$(docker ps -a --filter "name=${CONTAINER}" | grep -v 'CONTAINER ID')
echo

# If the container is not present, create it
if [[ "${container_ready}" == "" ]]
then
	echo "Creating the container..."
	set -x
	docker run -i -t -d \
			   --name "${CONTAINER}" \
			   -e DISPLAY=$DISPLAY \
			   -v /tmp/.X11-unix:/tmp/.X11-unix \
			   -v ${WORKSPACE}:/workspace \
			   ${IMAGE}
	set +x
	echo
fi
# --------------------------------------- #

# --------------------------------------- #
# Container start (if necessary)
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
# Print container informations
# --------------------------------------- #
# Container IP Address
IP_ADDRESS=$(docker inspect ansible_1 | grep \"IPA | head -n1 | awk -F '"' '{ print $4 }')

# Echo some infos
echo -e "---------------------------------------"
echo -e "Image name: \e[1m${IMAGE}\e[0m"
echo -e "Container name: \e[1m${CONTAINER}\e[0m"
echo -e "IP address: \e[1m${IP_ADDRESS}\e[0m"
echo -e "---------------------------------------"
echo
# --------------------------------------- #

# --------------------------------------- #
# Execute a shell on the container
# --------------------------------------- #
# At last execute a shell on the created container
set -x
docker exec -i -t ${CONTAINER} /bin/bash --login
# --------------------------------------- #
