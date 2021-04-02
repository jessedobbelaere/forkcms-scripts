#!/bin/bash

# Pull Assets
#
# Pull remote assets down from a remote to local

# Get the directory of the currently executing script
DIR="$(dirname "${BASH_SOURCE[0]}")"

# Include files
INCLUDE_FILES=(
            "common/defaults.sh"
            ".env.sh"
            "common/common_env.sh"
            )

for INCLUDE_FILE in "${INCLUDE_FILES[@]}"
do
    if [[ ! -f "${DIR}/${INCLUDE_FILE}" ]] ; then
        echo "File ${DIR}/${INCLUDE_FILE} is missing, aborting."
        exit 1
    fi
    source "${DIR}/${INCLUDE_FILE}"
done

# Make sure the remote assets directory exists
echo "Ensuring asset directory exists at '${REMOTE_ASSETS_PATH}'"
mkdir -p "${REMOTE_ASSETS_PATH}"

# Push the local asset dir files via rsync to the remote server
for DIR in "${LOCAL_ASSETS_DIRS[@]}"
do
    rsync -F -L -a -z -e "ssh -p ${REMOTE_SSH_PORT}" --delete-after --progress "${LOCAL_ASSETS_PATH}${DIR}" "${REMOTE_SSH_LOGIN}:${REMOTE_ASSETS_PATH}"
    echo "*** Synced assets from ${REMOTE_ASSETS_PATH}${DIR}"
done

# Normal exit
exit 0
