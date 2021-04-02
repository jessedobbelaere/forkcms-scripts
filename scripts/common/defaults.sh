#@IgnoreInspection BashAddShebang
# Fork CMS Scripts Defaults
#
# Default settings for Fork CMS scripts

# -- GLOBAL settings --

# The database driver for this install ('mysql' or 'pgsql')
GLOBAL_DB_DRIVER="mysql"

# -- LOCAL settings --

# Local path constants; paths should always have a trailing /
LOCAL_ROOT_PATH="REPLACE_ME"
LOCAL_ASSETS_PATH=${LOCAL_ROOT_PATH}"REPLACE_ME"

# Local asset directories relative to LOCAL_ASSETS_PATH that should be synched with remote assets
LOCAL_ASSETS_DIRS=(
                ""
                )

# Local database constants; default port for mysql is 3306, default port for postgres is 5432
LOCAL_DB_NAME="REPLACE_ME"
LOCAL_DB_PASSWORD="REPLACE_ME"
LOCAL_DB_USER="REPLACE_ME"
LOCAL_DB_HOST="localhost"
LOCAL_DB_PORT="3306"

# If you are using mysql 5.6.10 or later and you have `login-path` setup as per:
# https://opensourcedbms.com/dbms/passwordless-authentication-using-mysql_config_editor-with-mysql-5-6/
# you can use it instead of the above LOCAL_DB_* constants; otherwise leave this blank
LOCAL_DB_LOGIN_PATH=""

# The `mysql` and `mysqldump` commands to run locally
LOCAL_MYSQL_CMD="mysql"
LOCAL_MYSQLDUMP_CMD="mysqldump"

# -- REMOTE settings --

# Remote ssh credentials, user@domain.com and Remote SSH Port
REMOTE_SSH_LOGIN="REPLACE_ME"
REMOTE_SSH_PORT="22"

# Remote path constants; paths should always have a trailing /
REMOTE_ROOT_PATH="REPLACE_ME"
REMOTE_ASSETS_PATH=${REMOTE_ROOT_PATH}"REPLACE_ME"

# Should we connect to the remote database server via ssh?
REMOTE_DB_USING_SSH="yes"

# Remote database constants; default port for mysql is 3306, default port for postgres is 5432
REMOTE_DB_NAME="REPLACE_ME"
REMOTE_DB_PASSWORD="REPLACE_ME"
REMOTE_DB_USER="REPLACE_ME"
REMOTE_DB_HOST="localhost"
REMOTE_DB_PORT="3306"

# If you are using mysql 5.6.10 or later and you have `login-path` setup as per:
# https://opensourcedbms.com/dbms/passwordless-authentication-using-mysql_config_editor-with-mysql-5-6/
# you can use it instead of the above REMOTE_DB_* constants; otherwise leave this blank
REMOTE_DB_LOGIN_PATH=""

# The `mysql` and `mysqldump` commands to run remotely
REMOTE_MYSQL_CMD="mysql"
REMOTE_MYSQLDUMP_CMD="mysqldump"
