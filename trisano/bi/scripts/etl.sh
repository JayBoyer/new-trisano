#!/bin/sh

# Example ETL script
# Destination database must already exist

SOURCE_DB_HOST=localhost
SOURCE_DB_PORT=5432
SOURCE_DB_NAME=trisano_development
SOURCE_DB_USER=nedss
# NB!: Passwords must be handled automatically, i.e. with a .pgpass file
# cf. http://www.postgresql.org/docs/current/static/libpq-pgpass.html

DEST_DB_HOST=localhost
DEST_DB_PORT=5432
DEST_DB_NAME=trisano_warehouse
DEST_DB_USER=nedss

PGSQL_PATH=/usr/bin

# Set to 1 to avoid problems from bad assumptions
SAFE_MODE=0

## END OF CONFIG

## README

# This script uses pg_dump to dump the OLTP databsae (SOURCE_DB_* variables)
# into a warehouse database (DEST_DB_*). It will run one SQL script before it
# begins processing, and another after the dump completes, for doing the actual
# data manipulation required. It is expected that the whole process will
# involve the following steps:
# 1: dump the data to the public schema,
# 2: rename the public schema to "staging" or some such
# 3: create a new public schema
# 4: process the data in the staging schema
# 5: rename the staging schema once again, to something like warehouse_a or
#    warehouse_b
# 6: alter a set of views used by the actual reporting software to use the
#    newly-renamed schema instead of whatever they used before
# In other words, the reporting software only uses views to access the data.
# These views point at one schema (say, warehouse_a) while warehouse_b is being
# used for the refresh process. Once warehouse_b is built, the ETL process
# switches all the views to use warehouse_b, and warehouse_a gets used for the
# next refresh.
#
# See the individual ETL SQL scripts for further details

## END OF README

# TODO: Integrate this?
ETL_SCRIPT=dw.sql

echo "Preparing for ETL process"
$PGSQL_PATH/psql -X -h $DEST_DB_HOST -p $DEST_DB_PORT -U $DEST_DB_USER -d $DEST_DB_NAME <<PRE_ETL
    BEGIN;
    DROP SCHEMA staging CASCADE;
    COMMIT;

    BEGIN;
    CREATE SCHEMA staging;
    COMMIT;
PRE_ETL

if [ $? != 0 ] ; then
    echo "Problem preparing for ETL"
    exit 1
fi

echo "Dumping database $SOURCE_DB_HOST:$SOURCE_DB_PORT/$SOURCE_DB_NAME to $DEST_DB_HOST:$DEST_DB_PORT/$DEST_DB_NAME"
$PGSQL_PATH/pg_dump -h $SOURCE_DB_HOST -p $SOURCE_DB_PORT -U $SOURCE_DB_USER -n public $SOURCE_DB_NAME | \
    $PGSQL_PATH/psql -X -h $DEST_DB_HOST -p $DEST_DB_PORT -U $DEST_DB_USER $DEST_DB_NAME 

if [ $? != 0 ] ; then
    echo "Problem dumping database into warehouse staging area"
    exit 1
fi

echo "Performing ETL data manipulation"
$PGSQL_PATH/psql -X -h $DEST_DB_HOST -p $DEST_DB_PORT -U $DEST_DB_USER -f $ETL_SCRIPT $DEST_DB_NAME

if [ $? != 0 ] ; then
    echo "Problem performing post-dump ETL"
    exit 1
fi

echo "Swapping schemata"
CURRENT_SCHEMA=$($PGSQL_PATH/psql -A -t -q -X -h $DEST_DB_HOST -p $DEST_DB_PORT -U $DEST_DB_USER -c "SELECT * FROM trisano.current_schema_name" $DEST_DB_NAME)

if [ $? != 0 ]; then
    if [ $SAFE_MODE = 1 ]; then
        echo "Exiting to avoid bad assumption"
        exit 1
    fi
    echo "Warehouse tracking table probably doesn't exist. Assuming warehouse_a is currently public"
    CURRENT_SCHEMA='warehouse_a'
fi
if [ $CURRENT_SCHEMA = "warehouse_a" ]; then
    CURRENT_SCHEMA="warehouse_b"
else
    CURRENT_SCHEMA="warehouse_a"
fi

echo "Destination schema: $CURRENT_SCHEMA"
$PGSQL_PATH/psql -X -h $DEST_DB_HOST -p $DEST_DB_PORT -U $DEST_DB_USER -d $DEST_DB_NAME <<SWAP_SCHEMAS
    BEGIN;
        DROP SCHEMA $CURRENT_SCHEMA CASCADE;
    COMMIT;
    BEGIN;
        DROP TABLE trisano.current_schema_name;
    COMMIT;
    BEGIN;
        CREATE TABLE trisano.current_schema_name (schemaname TEXT);
        ALTER SCHEMA staging RENAME TO $CURRENT_SCHEMA;
        INSERT INTO  trisano.current_schema_name VALUES ('$CURRENT_SCHEMA');
    COMMIT;
SWAP_SCHEMAS

if [ $? != 0 ]; then
    echo "Failed to swap schemata"
    exit 1
fi

# TODO: Create views

echo "Successfully finished ETL process using schema $CURRENT_SCHEMA"
