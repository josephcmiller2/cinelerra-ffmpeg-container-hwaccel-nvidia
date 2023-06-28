#!/bin/sh

CPATH=$(realpath $(dirname "$0"))

. "${CPATH}/config"

if [[ "$1" == "" ]]; then
    EXTRAARGS="$EXTRAARGS -v ${CPATH}/bcast:/root/.bcast:rw"
else
    BCASTSESS="$1"
    if [[ ! -d "${CPATH}/bcast-${BCASTSESS}" ]]; then
        mkdir "${CPATH}/bcast-${BCASTSESS}"
    fi
    EXTRAARGS="$EXTRAARGS -v ${CPATH}/bcast-${BCASTSESS}:/root/.bcast:rw"
fi

EXTRAARGS="$EXTRAARGS -v ${CPATH}/bin:/root/bin:rw"
EXTRAARGS="$EXTRAARGS -e PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/cinelerra-8:/root/bin"


podman run ${RUNARGS} --hostname "${HOSTNAME}" --name "${NAME}" ${X11ARGS} ${FUSEARGS} ${SHAREDARGS} ${EXTRAARGS} "${TAGNAME}" /bin/bash
podman stop "${NAME}"
podman rm "${NAME}"

