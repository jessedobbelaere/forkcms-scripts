#!/bin/bash

# Common Env
#
# Shared script to set various environment-related variables

# Commands to output database dumps, using gunzip -c instead of zcat for MacOS X compatibility
DB_ZCAT_CMD="gunzip -c"
DB_CAT_CMD="cat"
