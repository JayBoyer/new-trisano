#!/bin/sh

# Copyright (C) 2007, 2008, 2009 The Collaborative Software Foundation
#
# This file is part of TriSano.
#
# TriSano is free software: you can redistribute it and/or modify it under the
# terms of the GNU Affero General Public License as published by the
# Free Software Foundation, either version 3 of the License,
# or (at your option) any later version.
#
# TriSano is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with TriSano. If not, see http://www.gnu.org/licenses/agpl-3.0.txt.

# Step 1: Copy XML config files
# Step 2: Copy custom jar files
# Step 3: Configure BI for Postgres
# Step 4: Customize admin console
# Step 5: Pre-publish OLAP schema
# Step 6: Tar it all up

if [ $# != 2 ] ; then
    echo ""
    echo "USAGE: $0 path_to_all_bi_products path_to_trisano_source_code"
    echo ""
    echo "Create a single directory into which you have downloaded all the relevant Pentaho"
    echo "Community bits: BI Server, Report Designer, Pentaho Metadata.  Provide that directory"
    echo "name as the first argument.  The second argument is the path to your local TriSano"
    echo "working copy."
    echo ""
    exit
fi

BI_BITS_HOME=${1%/}
TRISANO_SOURCE_HOME=${2%/}

if [ ! -d $BI_BITS_HOME ]; then
    echo "$BI_BITS_HOME is not a directory"
    exit
fi

if [ ! -d $TRISANO_SOURCE_HOME/bi ]; then
    echo "$TRISANO_SOURCE_HOME is not the root directory of the TriSano source tree"
    exit
fi

# VERIFY THESE NAMES BEFORE RUNNING SCRIPT
BI_SERVER_ZIP=biserver-ce-CITRUS-M2.tar.gz
REPORT_DESIGNER_ZIP=prd-ce-CITRUS-M4.zip
METADATA_ZIP=pme-ce-3.0.0.RC2.zip

BI_SERVER_HOME=$BI_BITS_HOME/biserver-ce
ADMIN_CONSOLE_HOME=$BI_BITS_HOME/administration-console

cd $BI_BITS_HOME

if [ ! -e $BI_SERVER_ZIP ]; then
    echo "Could not locate BI Server archiver $BI_BITS_HOME/$BI_SERVER_ZIP"
    exit
fi

if [ ! -e $REPORT_DESIGNER_ZIP ]; then
    echo "Could not locate Report Designer archive: $BI_BITS_HOME/$REPORT_DESIGNER_ZIP"
    exit
fi

if [ ! -e $METADATA_ZIP ]; then
    echo "Could not locate Pentaho Metadata archive: $BI_BITS_HOME/$METADATA_ZIP"
    exit
fi

# Step 0: Explode the BI server
echo "Exploding the BI Server archive"
tar zxf $BI_SERVER_ZIP

# Step 1: Copy SiteMinder XML config files
echo "Configuring BI Server to use SiteMinder"

# Backup originals
cp $BI_SERVER_HOME/pentaho-solutions/system/applicationContext-acegi-security.xml $BI_SERVER_HOME/pentaho-solutions/system/applicationContext-acegi-security.xml.org
cp $BI_SERVER_HOME/pentaho-solutions/system/pentaho-spring-beans.xml $BI_SERVER_HOME/pentaho-solutions/system/pentaho-spring-beans.xml.org
cp $BI_SERVER_HOME/pentaho-solutions/system/pentaho.xml $BI_SERVER_HOME/pentaho-solutions/system/pentaho.xml.org

# Copy in new ones
cp $TRISANO_SOURCE_HOME/bi/bi_server_replacement_files/applicationContext-acegi-security-siteminder.xml $BI_SERVER_HOME/pentaho-solutions/system/
cp $TRISANO_SOURCE_HOME/bi/bi_server_replacement_files/applicationContext-acegi-security.xml $BI_SERVER_HOME/pentaho-solutions/system/
cp $TRISANO_SOURCE_HOME/bi/bi_server_replacement_files/pentaho-spring-beans.xml $BI_SERVER_HOME/pentaho-solutions/system/
cp $TRISANO_SOURCE_HOME/bi/bi_server_replacement_files/pentaho.xml $BI_SERVER_HOME/pentaho-solutions/system/

# Step 2: Copy custom jar files
echo "Copying Trisano custom java extensions to BI Server"
cp $TRISANO_SOURCE_HOME/bi/extensions/trisano/dist/* $BI_SERVER_HOME/tomcat/webapps/pentaho/WEB-INF/lib

# Step 3: Configure BI for Postgres
echo "Configuring BI Server to use PostgreSQL"
# Backup originals
cp $BI_SERVER_HOME/start-pentaho.sh $BI_SERVER_HOME/start-pentaho.sh.org
cp $BI_SERVER_HOME/stop-pentaho.sh $BI_SERVER_HOME/stop-pentaho.sh.org
cp $BI_SERVER_HOME/pentaho-solutions/system/quartz/quartz.properties  $BI_SERVER_HOME/pentaho-solutions/system/quartz/quartz.properties.org 
cp $BI_SERVER_HOME/pentaho-solutions/system/hibernate/hibernate-settings.xml $BI_SERVER_HOME/pentaho-solutions/system/hibernate/hibernate-settings.xml.org
cp $BI_SERVER_HOME/tomcat/webapps/pentaho/META-INF/context.xml $BI_SERVER_HOME/tomcat/webapps/pentaho/META-INF/context.xml.org

# Copy in new ones
cp $TRISANO_SOURCE_HOME/bi/bi_server_replacement_files/start-pentaho.sh $BI_SERVER_HOME
cp $TRISANO_SOURCE_HOME/bi/bi_server_replacement_files/stop-pentaho.sh $BI_SERVER_HOME
cp $TRISANO_SOURCE_HOME/bi/bi_server_replacement_files/quartz.properties $BI_SERVER_HOME/pentaho-solutions/system/quartz/
cp $TRISANO_SOURCE_HOME/bi/bi_server_replacement_files/hibernate-settings.xml $BI_SERVER_HOME/pentaho-solutions/system/hibernate
cp $TRISANO_SOURCE_HOME/bi/bi_server_replacement_files/context.xml $BI_SERVER_HOME/tomcat/webapps/pentaho/META-INF

# Step 4: Customize admin console
# Add Postgres JDBC driver to admin-console
echo "Configuring Admin Console to use PostgreSQL"
cp $BI_SERVER_HOME/tomcat/common/lib/postgresql-8.2-504.jdbc3.jar $ADMIN_CONSOLE_HOME/jdbc/

# Step 6: Create a TriSano tarball
echo "Creating distribution package"
tar cfz trisano-bi.tar.gz $BI_SERVER_HOME $ADMIN_CONSOLE_HOME $REPORT_DESIGNER_ZIP $METADATA_ZIP

# Clean up
rm -fr $BI_SERVER_HOME $ADMIN_CONSOLE_HOME

echo
echo "$BI_BITS_HOME/trisano-bi.tar.gz is ready for shipping."
