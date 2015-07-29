#!/bin/bash
#
# stop docker container

container_name='caldavd'

# if running on linux
if [ $(id -u) -ne 0 ]; then
    sudo="sudo"
fi


${sudo} docker stop ${container_name}
