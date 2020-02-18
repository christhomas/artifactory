#!/usr/bin/env bash

function set_required () {
    eval v="\$$1";

    if [ -z "$v" ]; then
        echo "$1 envvar is not configured, exiting..."
        exit 0;
    else
        [ ! -z "${ENTRYPOINT_DEBUG}" ] && echo "Rewriting required variable '$1' in file '$2'"
        sed -i "s~{{ $1 }}~$v~g" $2
    fi
}

mkdir /var/opt/jfrog/artifactory/etc
mkdir -p /var/opt/jfrog/artifactory/etc/security
echo ${MASTER_KEY} >> /var/opt/jfrog/artifactory/etc/security/master.key
echo /var/opt/jfrog/artifactory/etc/security/master.key

set_required S3_CREDENTIALS /artifactory_extra_conf/binarystore.xml
set_required S3_IDENTITY /artifactory_extra_conf/binarystore.xml
set_required S3_BUCKET_NAME /artifactory_extra_conf/binarystore.xml

/entrypoint-artifactory.sh
