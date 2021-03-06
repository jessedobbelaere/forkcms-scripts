#!/bin/bash

# Pull Database
#
# Pull remote database down from a remote and restore it to local

# Get the directory of the currently executing script
DIR="$(dirname "${BASH_SOURCE[0]}")"

# Include files
INCLUDE_FILES=(
            "common/defaults.sh"
            ".env.sh"
            "common/common_env.sh"
            "common/common_db.sh"
            )
for INCLUDE_FILE in "${INCLUDE_FILES[@]}"
do
    if [[ ! -f "${DIR}/${INCLUDE_FILE}" ]] ; then
        echo "File ${DIR}/${INCLUDE_FILE} is missing, aborting."
        exit 1
    fi
    source "${DIR}/${INCLUDE_FILE}"
done

# Temporary db dump path (remote & local)
TMP_DB_PATH="/tmp/${REMOTE_DB_NAME}-db-dump-$(date '+%Y%m%d').sql"
BACKUP_DB_PATH="/tmp/${LOCAL_DB_NAME}-db-backup-$(date '+%Y%m%d').sql"

# Functions
function copy_db_dump_locally() {
    # If the database dump was done remotely, copy it down locally
    scp -P $REMOTE_SSH_PORT -- $REMOTE_SSH_LOGIN:"${TMP_DB_PATH}.gz" "${TMP_DB_PATH}.gz"
}
function pull_mysql_direct() {
    # Connect to the database server directly
    $REMOTE_MYSQLDUMP_CMD $REMOTE_DB_CREDS $MYSQLDUMP_SCHEMA_ARGS > "${TMP_DB_PATH}"
    $REMOTE_MYSQLDUMP_CMD $REMOTE_DB_CREDS $REMOTE_IGNORED_DB_TABLES_STRING $MYSQLDUMP_DATA_ARGS >> "${TMP_DB_PATH}"
    gzip -f "${TMP_DB_PATH}"
}
function pull_mysql_ssh() {
    # The database server requires ssh'ing in to connect to it
    ssh $REMOTE_SSH_LOGIN -p $REMOTE_SSH_PORT "$REMOTE_MYSQLDUMP_CMD $REMOTE_DB_CREDS $MYSQLDUMP_SCHEMA_ARGS > '$TMP_DB_PATH' ; $REMOTE_MYSQLDUMP_CMD $REMOTE_DB_CREDS $REMOTE_IGNORED_DB_TABLES_STRING $MYSQLDUMP_DATA_ARGS >> '$TMP_DB_PATH' ; gzip -f '$TMP_DB_PATH'"
    copy_db_dump_locally
}
function backup_local_mysql() {
    $LOCAL_MYSQLDUMP_CMD $LOCAL_DB_CREDS $MYSQLDUMP_SCHEMA_ARGS > "$BACKUP_DB_PATH"
    $LOCAL_MYSQLDUMP_CMD $LOCAL_DB_CREDS $LOCAL_IGNORED_DB_TABLES_STRING $MYSQLDUMP_DATA_ARGS >> "$BACKUP_DB_PATH"
    gzip -f "$BACKUP_DB_PATH"
    echo "*** Backed up local database to ${BACKUP_DB_PATH}.gz"
}
function restore_local_from_remote_mysql() {
    ${DB_ZCAT_CMD} "${TMP_DB_PATH}.gz" | $LOCAL_MYSQL_CMD $LOCAL_DB_CREDS
    ssh $REMOTE_SSH_LOGIN -p $REMOTE_SSH_PORT "$REMOTE_MYSQLDUMP_CMD $REMOTE_DB_CREDS $MYSQLDUMP_SCHEMA_ARGS > '$TMP_DB_PATH' ;"
    echo "*** Restored local database from ${TMP_DB_PATH}.gz"
}

# Source the correct file for the database driver
case "$GLOBAL_DB_DRIVER" in
    ( 'mysql' )
        source "${DIR}/common/common_mysql.sh"
        if [[ "${REMOTE_DB_USING_SSH}" == "yes" ]] ; then
            pull_mysql_ssh
        else
            pull_mysql_direct
        fi
        backup_local_mysql
        restore_local_from_remote_mysql
        ;;
    ( * )
        echo "Environment variable GLOBAL_DB_DRIVER was not 'mysql'. Aborting."
        exit 1 ;;
esac

# Normal exit
exit 0
