#!/bin/bash

# Push Database
#
# Push local database to the remote

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
TMP_DB_PATH="/tmp/${LOCAL_DB_NAME}-db-dump-$(date '+%Y%m%d').sql"
BACKUP_DB_PATH="/tmp/${REMOTE_DB_NAME}-db-backup-$(date '+%Y%m%d').sql"

# Functions
function copy_db_dump_remote() {
    # If the database dump was done locally, copy it to the remote
    scp -P $REMOTE_SSH_PORT -- "${TMP_DB_PATH}.gz" "$REMOTE_SSH_LOGIN:${TMP_DB_PATH}.gz"
}
function push_mysql_direct() {
    # TBD
    exit 1
}
function push_mysql_ssh() {
    # The database server requires ssh'ing in to connect to it
    copy_db_dump_remote
}
function dump_local_mysql() {
    # Dump the local db to .sql.gz
    $LOCAL_MYSQLDUMP_CMD $LOCAL_DB_CREDS $MYSQLDUMP_SCHEMA_ARGS > "$TMP_DB_PATH"
    $LOCAL_MYSQLDUMP_CMD $LOCAL_DB_CREDS $LOCAL_IGNORED_DB_TABLES_STRING $MYSQLDUMP_DATA_ARGS >> "$TMP_DB_PATH"
    gzip -f "$TMP_DB_PATH"
    echo "*** Dumped local database to ${TMP_DB_PATH}.gz"
}
function backup_remote_mysql_ssh() {
    # The database server requires ssh'ing in to connect to it
    ssh $REMOTE_SSH_LOGIN -p $REMOTE_SSH_PORT "$REMOTE_MYSQLDUMP_CMD $REMOTE_DB_CREDS $MYSQLDUMP_SCHEMA_ARGS > '$BACKUP_DB_PATH' ; $REMOTE_MYSQLDUMP_CMD $REMOTE_DB_CREDS $REMOTE_IGNORED_DB_TABLES_STRING $MYSQLDUMP_DATA_ARGS >> '$BACKUP_DB_PATH' ; gzip -f '$BACKUP_DB_PATH'"
}
function backup_remote_mysql_direct() {
    $REMOTE_MYSQLDUMP_CMD $REMOTE_DB_CREDS $MYSQLDUMP_SCHEMA_ARGS > "${BACKUP_DB_PATH}"
    $REMOTE_MYSQLDUMP_CMD $REMOTE_DB_CREDS $REMOTE_IGNORED_DB_TABLES_STRING $MYSQLDUMP_DATA_ARGS >> "${BACKUP_DB_PATH}"
    gzip -f "${BACKUP_DB_PATH}"
}
function restore_remote_from_local_mysql() {
    ssh $REMOTE_SSH_LOGIN -p $REMOTE_SSH_PORT "${DB_ZCAT_CMD} "${TMP_DB_PATH}.gz" | $REMOTE_MYSQL_CMD $REMOTE_DB_CREDS"
    echo "*** Restored remote database from ${TMP_DB_PATH}.gz"
}

# Source the correct file for the database driver
case "$GLOBAL_DB_DRIVER" in
    ( 'mysql' )
        source "${DIR}/common/common_mysql.sh"
        dump_local_mysql
        if [[ "${REMOTE_DB_USING_SSH}" == "yes" ]] ; then
            push_mysql_ssh
            backup_remote_mysql_ssh
        else
            push_mysql_direct
            backup_remote_mysql_direct
        fi
        restore_remote_from_local_mysql
        ;;
    ( * )
        echo "Environment variable GLOBAL_DB_DRIVER was not 'mysql'. Aborting."
        exit 1 ;;
esac

# Normal exit
exit 0
