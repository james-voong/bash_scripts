#!/bin/bash

# This file contains functions some useful functions and aliases for use in db containers.

alias psql='psql -U moodle -h localhost'

recreatedb {
    psql -d postgres -c "DROP DATABASE moodle";
    psql -d postgres -c "CREATE DATABASE moodle WITH OWNER moodle";
}

restoredb {
    if [ ${#} -ne 1 ]; then
        echo "Invalid number of arguments supplied."
        exit 0;
    fi
    recreatedb
	pg_restore -h localhost -U moodle -v -O --role moodle -d moodle ${1};
}
