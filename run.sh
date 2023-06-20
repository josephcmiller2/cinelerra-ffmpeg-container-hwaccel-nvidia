#!/bin/sh

CPATH=$(realpath $(dirname "$0"))

. "${CPATH}/config"

EXTRAARGS="$EXTRAARGS -v ${CPATH}/bcast:/root/.bcast:rw -v ${CPATH}/bin:/root/bin:rw"
#EXTRAARGS="$EXTRAARGS -e PATH=/root/cinelerra-8:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
EXTRAARGS="$EXTRAARGS -e PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/cinelerra-8:/root/bin"

if [[ "$1" == "" ]]; then
    CMD=/usr/bin/startcontainer.sh
fi
podman run ${RUNARGS} --hostname "${HOSTNAME}" --name "${NAME}" ${X11ARGS} ${FUSEARGS} ${SHAREDARGS} ${EXTRAARGS} "${TAGNAME}" /bin/bash
#podman exec ${RUNARGS} "${NAME}" "${CMD}" "$@"
podman stop "${NAME}"
podman rm "${NAME}"

