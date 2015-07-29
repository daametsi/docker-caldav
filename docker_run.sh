#!/bin/bash
#
# create a new docker container

container_name=caldavd

# relative path to volume
volume=opt2/CalendarServer/data  # avoid confusion with /opt/..

usage()
{
cat << EOF
usage: options

OPTIONS
    -c  Delete all files in log dir and exit
    -d  Run as daemon
    -v  Show data volume mount paths
    -h  Show this message

EOF
exit 0
}

detachmode='--detach=false --rm=true'  # run container in foreground and remove it on exit

while getopts "cdhvx" OPTION
do
        case $OPTION in
                c)
                        rm -f ./${volume}/log/*
                        echo "Deleted /${volume}/log directory."
                        exit 0
                        ;;
                d)
                        detachmode='--detach=true --rm=false'
                        ;;
                v)
                        echo "mounting data volume (host:container): ${dir}/${volume}:/${volume}"
                        exit 0
                        ;;
                x)
                        echo "only showing execution command"
                        noexec="true"
                        ;;
                h)
                        usage
                        ;;
                ?)
                        usage
                        ;;
        esac
done

#absolute dirname of script
dir=$(dirname `which $0`)

. ${dir}/image_name.sh


# if running on linux
if [ $(id -u) -ne 0 ]; then
    sudo="sudo"
fi

if ${sudo} docker ps | awk '{print $NF}' | grep -qx ${container_name}; then
    echo "$0: Docker container with name $name already running. Press enter to restart it, or ctrl+c to abort."
    exit 0
fi

$sudo docker rm ${name} > /dev/null 2> /dev/null


# Arguments to start pyff:
export LOGLEVEL=INFO
export LOGFILE=/opt2/var/log/pyff.log
export PIPELINE=/opt2/etc/md.fd

# cron will invoke pyff every PERIOD minutes (1..59)
if [ -z "$PERIOD" ]; then
   export PERIOD="10"
fi


if $sudo docker ps -a |grep -q "${container_name}"; then
    ${sudo} docker rm ${container_name}  # needed for batch mode
fi



# To debug your container:
#DOCKERARGS="--entrypoint /bin/bash" bash -x ./run.sh

exec=$(cat << EOF
${sudo} docker run --rm=true \
    ${detachmode} \
    --hostname="${container_name}" \
    --name="${container_name}" \
    --volume=${dir}/${volume}:/${volume} \
    $DOCKERARGS \
    -i -t \
    ${image}
EOF
)

if [ -z ${noexec} ]; then
    ${exec};
else
    echo ${exec};
fi
