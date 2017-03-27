#!/usr/bin/env bash

set -eu

# See https://postgrest.com/en/v0.4/admin.html#configuration

# Check if POSTGRES_USER has been set, otherwise fail
if [ -z ${POSTGRES_USER+x} ]; then
    echo "Need to specify the POSTGRES_USER environment variable. Exiting..."
    exit 1;
fi

# Check if POSTGRES_PASSWORD has been set, otherwise fail
if [ -z ${POSTGRES_PASSWORD+x} ]; then
    echo "Need to specify the POSTGRES_PASSWORD environment variable. Exiting..."
    exit 1;
fi

# Check if POSTGRES_DATABASE has been set, otherwise fail
if [ -z ${POSTGRES_DATABASE+x} ]; then
    echo "Need to specify the POSTGRES_DATABASE environment variable. Exiting..."
    exit 1;
fi

# Check if POSTGRES_SCHEMA has been set, otherwise fail
if [ -z ${POSTGRES_SCHEMA+x} ]; then
    echo "Need to specify the POSTGRES_SCHEMA environment variable. Exiting..."
    exit 1;
fi

# Check if POSTGRES_URL has been set, otherwise set default
if [ -z ${POSTGRES_URL+x} ]; then
    export POSTGRES_URL=postgresql.marathon.l4lb.thisdcos.directory:5432
    echo "Using default POSTGRES_URL: postgresql.marathon.l4lb.thisdcos.directory:5432"
fi

# Check if POSTGRES_TIMEOUT_SECONDS has been set, otherwise set default
if [ -z ${POSTGRES_TIMEOUT_SECONDS+x} ]; then
    export POSTGRES_TIMEOUT_SECONDS=120
    echo "Using default POSTGRES_TIMEOUT_SECONDS: 120"
fi

# Check if POSTGREST_JWT_SECRET has been set, otherwise set default
if [ -z ${POSTGREST_JWT_SECRET+x} ]; then
    export POSTGREST_JWT_SECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    echo "Generated POSTGREST_JWT_SECRET: ${POSTGREST_JWT_SECRET}"
fi

# Check if POSTGREST_DB_MAX_ROWS has been set, otherwise set default
if [ -z ${POSTGREST_DB_MAX_ROWS+x} ]; then
    export POSTGREST_DB_MAX_ROWS=1000
    echo "Using default POSTGREST_DB_MAX_ROWS: 1000"
fi

# Check if POSTGREST_DB_POOL_SIZE has been set, otherwise set default
if [ -z ${POSTGREST_DB_POOL_SIZE+x} ]; then
    export POSTGREST_DB_POOL_SIZE=5
    echo "Using default POSTGREST_DB_POOL_SIZE: 5"
fi

# Check if POSTGREST_ANON_ROLE has been set, otherwise set default
if [ -z ${POSTGREST_ANON_ROLE+x} ]; then
    export POSTGREST_ANON_ROLE="app_user"
    echo "Using default POSTGREST_ANON_ROLE: app_user"
fi

# Show environment
env

# Render config.conf and start postgrest
dockerize -delims "<%:%>" -template $POSTGREST_PATH/config.conf.template:$POSTGREST_PATH/config.conf -wait tcp://$POSTGRES_URL -timeout ${POSTGRES_TIMEOUT_SECONDS}s cat $POSTGREST_PATH/config.conf && postgrest $POSTGREST_PATH/config.conf