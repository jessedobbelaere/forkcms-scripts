<div align="center">
  <a href="https://github.com/forkcms/forkcms">
      <img width="200" height="200" src="https://i.imgur.com/oh7i1rX.png">
  </a>
  <img width="200" height="200" vspace="" hspace="25" src="https://upload.wikimedia.org/wikipedia/commons/4/4b/Bash_Logo_Colored.svg">
  <h1>Fork CMS scripts</h1>
</div>

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat)](http://makeapullrequest.com)

Shell scripts to manage **asset syncing** and **database syncing** between [Fork CMS](https://www.fork-cms.com) environments. Using these scripts you can pull assets and database data from remote to local, or the reverse way: push your local database and assets to your (staging/production) environment.

## Overview

There are several scripts included in forkcms-scripts, each of which perform different functions. They all use a shared `.env.sh` to function. This `.env.sh` should be created on each environment where you wish to run the forkcms-scripts, and it should be excluded from your git repo via `.gitignore`.

## Installation

-   Copy the scripts folder into the root directory of your Fork CMS project, or a subfolder like `var/`
-   Duplicate the `example.env.sh` file, and rename it to .env.sh
-   Add .env.sh to your .gitignore file!
-   Then open up the .env.sh file into your favorite editor, and configure appropriately.

### `pull_db.sh`

The `pull_db.sh` script pulls down a database dump from a remote server, and then dumps it into your local database. It backs up your local database before doing the dump.

### `push_db.sh`

The `push_db.sh` script creates a local database dump, and then dumps it into your remote database. It backs up your remote database before doing the dump.

### `pull_assets.sh`

The `pull_assets.sh` script pulls down an arbitrary number of directories from a remote server, since we keep client-uploadable assets out of the git repo. The directories it will pull down are specified in `LOCAL_ASSETS_DIRS`, e.g.

```bash
LOCAL_ASSETS_DIRS=(
    "Blog"
    "Core"
    "MediaLibrary"
    "Pages"
    "Users"
)
```

### `push_assets.sh`

The `push_assets.sh` script pushes an arbitrary number of directories from your local machine to the remote server, since we keep client-uploadable assets out of the git repo. The directories it will push are specified in `LOCAL_ASSETS_DIRS`.

## Credits

-   https://github.com/sgruhier/capistrano-db-tasks
-   https://nystudio107.com/blog/database-asset-syncing-between-environments-in-craft-cms
