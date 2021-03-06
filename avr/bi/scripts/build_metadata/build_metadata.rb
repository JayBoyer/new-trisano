# Copyright (C) 2007, 2008, 2009, 2010, 2011, 2012, 2013
# The Collaborative Software Foundation
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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with TriSano. If not, see http://www.gnu.org/licenses/agpl-3.0.txt.

require 'java'
require 'fileutils'
require 'yaml'

def verbose
  ENV['VERBOSE'] && ENV['VERBOSE'] != 'false' ? true : false
end

def server_dir
  ENV['BI_SERVER_PATH'] || '/usr/local/pentaho/server/biserver-ce'
end

def database_driver_class
  ENV['TRISANO_DB_DRIVER'] || 'org.postgresql.Driver'
end

def database_user
  ENV['TRISANO_DB_USER'] || 'dw_priv_user'
end

def database_password
  ENV['TRISANO_DB_PASSWORD'] || 'dw_priv_user'
end

def database_url
  ENV['TRISANO_JDBC_URL'] || 'jdbc:postgresql://localhost:5432/trisano_warehouse'
end

def bi_user
  ENV['BI_USER_NAME'] || 'joe'
end

def bi_password
  ENV['BI_USER_PASSWORD'] || 'password'
end

def bi_server_url
  ENV['BI_SERVER_URL'] || 'http://127.0.0.1:8080'
end

def publish_url
    ENV['BI_PUBLISH_URL'] || (bi_server_url + '/pentaho/RepositoryFilePublisher')
end

def publisher_password
    ENV['BI_PUBLISH_PASSWORD'] || 'password'
end

def pentaho_security_file
  file = ENV['PENTAHO_SECURITY_FILE'] || ''
  if test ?r, file then
    return file
  else
    return nil
  end
end

def trisano_db_host
  ENV['TRISANO_DB_HOST'] || '127.0.0.1'
end

def trisano_db_port
  ENV['TRISANO_DB_PORT'] || '5432'
end

def trisano_db_name
  ENV['TRISANO_DB_NAME'] || 'trisano_warehouse'
end

def trisano_db_user
  ENV['TRISANO_DB_USER'] || 'trisano_dw'
end

def trisano_db_password
  ENV['TRISANO_DB_PASSWORD'] || 'trisano_dw'
end

def plugin_directory
  ENV['TRISANO_PLUGIN_DIRECTORY'] || '../../../plugins'
end

def require_jars(jars)
  jars.each {|jar| require jar}
end

require_jars Dir.glob(File.join(server_dir, 'tomcat/webapps/pentaho/WEB-INF/lib', '*.jar'))
require_jars Dir.glob(File.join(server_dir, 'tomcat/common/lib', 'postgres*.jar'))

AllTablesGroupName = 'All Formbuilder Tables';
DefaultFieldType = Java::OrgPentahoPmsSchemaConceptTypesFieldtype::FieldTypeSettings::DIMENSION
MaxX = 800

CWM = Java::OrgPentahoPmsCore::CWM
CwmSchemaFactory = Java::OrgPentahoPmsFactory::CwmSchemaFactory
Relationship = Java::OrgPentahoPmsSchema::RelationshipMeta
BusinessModel = Java::OrgPentahoPmsSchema::BusinessModel
BusinessTable = Java::OrgPentahoPmsSchema::BusinessTable
BusinessCategory = Java::OrgPentahoPmsSchema::BusinessCategory
BusinessColumn = Java::OrgPentahoPmsSchema::BusinessColumn
PhysicalColumn = Java::OrgPentahoPmsSchema::PhysicalColumn
PhysicalTable = Java::OrgPentahoPmsSchema::PhysicalTable
PublisherUtil = Java::OrgPentahoPlatformUtilClient::PublisherUtil
SecurityOwner = Java::OrgPentahoPmsSchemaSecurity::SecurityOwner
SchemaMeta = Java::OrgPentahoPmsSchema::SchemaMeta
KettleEnvironment = Java::OrgPentahoDiCore::KettleEnvironment
AggregationSettings = Java::OrgPentahoPmsSchemaConceptTypesAggregation::AggregationSettings
Concept = Java::OrgPentahoPmsSchemaConcept::Concept
ConceptPropertyLocalizedString = Java::OrgPentahoPmsSchemaConceptTypesLocalstring::ConceptPropertyLocalizedString
ConceptPropertyString = Java::OrgPentahoPmsSchemaConceptTypesString::ConceptPropertyString
ConceptPropertyTableType = Java::OrgPentahoPmsSchemaConceptTypesTabletype::ConceptPropertyTableType
ConceptPropertyNumber = Java::OrgPentahoPmsSchemaConceptTypesNumber::ConceptPropertyNumber
DataTypeSettings = Java::OrgPentahoPmsSchemaConceptTypesDatatype::DataTypeSettings
LocalizedStringSettings = Java::OrgPentahoPmsSchemaConceptTypesLocalstring::LocalizedStringSettings
TableTypeSettings = Java::OrgPentahoPmsSchemaConceptTypesTabletype::TableTypeSettings
DatabaseMeta = Java::OrgPentahoDiCoreDatabase::DatabaseMeta
SecurityService = Java::OrgPentahoPmsSchemaSecurity::SecurityService
SecurityReference = Java::OrgPentahoPmsSchemaSecurity::SecurityReference
BooleanProperty = Java::OrgPentahoPmsSchemaConceptTypesBool::ConceptPropertyBoolean
OperationName = 'Rebuild Reporting Metadata'

$event_types = {}

def db_connection
    props = Java::JavaUtil::Properties.new
    props.setProperty "user", database_user
    props.setProperty "password", database_password
    begin
      conn = create_db_connection.connect database_url, props
      conn.create_statement.execute_update("SET search_path = 'trisano'");
      yield conn
    #rescue
    #  e = $!
    #  puts "Some exception occurred: #{e}"
    #  raise e
    ensure
      conn.close if conn
    end
end

def create_db_connection
    eval("#{database_driver_class}").new
end

def get_query_results(query_string, conn)
    return nil if query_string.nil?
    rs = conn.prepare_call(query_string).execute_query
    res = []
    len = rs.getMetaData().getColumnCount()
    while rs.next
      val = {}
      (1..len).each do |i|
        val[rs.getMetaData().getColumnName(i)] = rs.getString(i)
      end
      res << val
    end
    return res
end

def setup_security_reference(meta)
  secref = SecurityReference.new
  secserv = secref.getSecurityService
  secserv.setDetailNameParameter('details')
  secserv.setDetailServiceType(0)
  secserv.setServiceName('SecurityDetails')
  secserv.setUsername(bi_user)
  secserv.setPassword(bi_password)
  secserv.setProxyHostname('')
  secserv.setProxyPort('')
  secserv.setNonProxyHosts('')
  if pentaho_security_file.nil?
    secserv.serviceURL = bi_server_url + '/pentaho/ServiceAction?action=SecurityDetails&details=all'
    puts "Getting Pentaho security from URL: " + secserv.serviceURL if verbose
  else
    secserv.setFilename pentaho_security_file
    puts "Getting Pentaho security from file: " + secserv.filename if verbose
  end

  meta.setSecurityReference(secref)
end

def role_type
  Java::OrgPentahoPmsSchemaSecurity::SecurityOwner::OWNER_TYPE_ROLE
end

def secure(obj)
  owner = Java::OrgPentahoPmsSchemaSecurity::SecurityOwner.new role_type, "Authenticated"
  security = Java::OrgPentahoPmsSchemaSecurity::Security.new
  security.putOwnerRights owner, -1

  obj.concept.add_property Java::OrgPentahoPmsSchemaConceptTypesSecurity::ConceptPropertySecurity.new('security', security)
end

def pentaho_roles(conn)
#  puts "Getting Pentaho's roles"
#  secserv = meta.securityReference.securityService
#  res = secserv.getRoles
#  raise "Couldn't get Pentaho's roles. Perhaps Pentaho isn't running?" if res.nil?

# These need to come from the list of available jurisdictions, as follows:
  
  res = []
  query_string = %{ 
    SELECT DISTINCT p.name FROM
    trisano.places_view p
      JOIN trisano.places_types_view pt 
        ON pt.place_id = p.id
      JOIN trisano.codes_view c
        ON c.id = pt.type_id AND c.code_description = 'Jurisdiction'
  }
  get_query_results(query_string, conn).each do |rs|
    res << rs['name']
  end
  res
end

def setup_role_security(model, dg, meta, juris, conn)
  puts "Setting up role-based security" if verbose
  rbsm = model.rowLevelSecurity.getRoleBasedConstraintMap

  # Remove existing rule set
  existing_rules = []
  rbsm.keySet.each do |mykey|
    existing_rules.push(mykey)
  end
  existing_rules.each do |rulename|
    rbsm.remove(rulename)
  end

  rbsm.put(Java::OrgPentahoPmsSchemaSecurity::SecurityOwner.new(1, 'Admin'), "1 = 1")

  pentaho_roles(conn).each do |rolename|
    puts "Checking out pentaho role #{rolename}" if verbose
    if juris[rolename] != nil then
      puts "  Found role match on #{rolename}" if verbose
      rbsm.put(Java::OrgPentahoPmsSchemaSecurity::SecurityOwner.new(1, rolename), "OR([dw_morbidity_events_view_#{dg}.dw_morbidity_events_view_investigating_jurisdiction_#{dg}]=\"#{rolename}\" ;  [dw_morbidity_secondary_jurisdictions_view_#{dg}.dw_morbidity_secondary_jurisdictions_view_name_#{dg}] = \"#{rolename}\")")
    end
  end
  model.rowLevelSecurity.set_type(Java::OrgPentahoPmsSchemaSecurity::RowLevelSecurity::Type::ROLEBASED)
  puts "Finished building row-level constraints" if verbose
end

def jurisdiction_query
  %{
    SELECT p.name AS name
    FROM trisano.places_view p
    JOIN trisano.places_types_view pt
        ON (p.id = pt.place_id)
    JOIN trisano.codes_view c
        ON (c.id = pt.type_id)
    WHERE c.code_description = 'Jurisdiction'
  }
end

def jurisdiction_hash(conn)
    res = {}
    get_query_results(jurisdiction_query, conn).each do |rs|
      res[rs['name']] = 1
    end
    return res
end

def initialize_model(model, meta)
  model.set_connection meta.find_database('TriSano')
# Sample code so we know how to push outer join conditions into the WHERE clause if need be
  model.concept.add_property BooleanProperty.new('delay_outer_join_conditions', true)
  secure model
  return model
end

def initialize_meta(meta)
  setup_security_reference meta
  dm = DatabaseMeta.new('TriSano', 'PostgreSQL', 'Native', trisano_db_host, trisano_db_name, trisano_db_port, trisano_db_user, trisano_db_password)
  meta.add_database dm
  return meta
end

def add_single_business_column(bt, pt, pc, id, name, descr, category, make_cat)
    bc = BusinessColumn.new id
    desc = descr
    desc.gsub!(/^col_/, '') if pt.get_target_table =~ /^fb_/
    bc.set_name 'en_US', desc
    bc.set_description 'en_US', desc
    bc.physical_column = pc
    bc.field_type = DefaultFieldType
    bc.business_table = bt
    bt.add_business_column bc
    if not category.nil? and make_cat == 'TRUE' then
      puts " *** Adding business column #{name} to category #{category.get_name 'en_US'}" if verbose
      category.add_business_column bc
    else
      puts " --- not adding business column #{name} to cateogry (#{make_cat}, category is #{category.nil? ? "nil" : "not nill"})" if verbose
    end
    return bc
end

def add_business_columns(bt, meta, category, dg, conn)
  puts "Adding business columns for table #{bt.id}" if verbose
  pt = bt.get_physical_table
  cols = get_query_results(columns_query(pt.get_target_table, pt.get_target_schema), conn).sort { |a,b| a['description'] <=> b['description'] }
  cols.each do |bcrow|
    pc = pt.find_physical_column "#{pt.get_id}_#{bcrow['name']}"
    if pc.nil?
      if verbose then
        pt.get_physical_columns.each do |a| puts a.get_id end
      end
      raise "Couldn't find physical column '#{pt.get_id}.#{bcrow['name']}' for new business column"
    end
    add_single_business_column bt, pt, pc, "#{pt.get_id}_#{bcrow['name']}_#{dg}", bcrow['name'], bcrow['description'], category, bcrow['make_category_column']
  end
end

def core_business_table_query(event_type)
  query = %{
    SELECT
        order_num,
        table_name AS business_table_name,
        CASE WHEN has_repeater THEN 1 ELSE 0 END AS repeat,
        disease_join_clause AS join_clause,
        table_description,
        relname AS physical_table_name,
        CASE
            WHEN make_category THEN 'TRUE'
            ELSE 'FALSE'
        END AS make_category,
        'FALSE',
        formbuilder_prefix
    FROM trisano.core_tables c JOIN pg_class pgc
        ON (pgc.oid = c.target_table::regclass)
    WHERE table_name !~ '#{event_type == 'A' ? 'dw_morbidity' : 'dw_assessment'}'
    AND table_name IS NOT NULL
    ORDER BY order_num, business_table_name
  }
end

def formbuilder_hstore_query(name, prefix, repeat, dg, join_clause)
    # name: The name of the table with the hstore field we want
    # prefix: the prefix of the hstore field we want
    # repeat: true if there's a repeater formbuilder hstore on this table
    # dg: the disease group name
    # join_clause: any SQL join clause that may be necessary to associate a
    #    disease_id with rows in this table

    # The point is to get all formbuilder fields for this disease group that
    # *aren't* associated with a repeating core field. Form fields attached to
    # a repeating core field are part of the core table in the business model.

    return %{
        WITH core_keys AS (
            #{ ! repeat ? %{
            SELECT
                disease_id,
                skeys(#{prefix}_formbuilder) AS key,
                'F'::BOOLEAN AS repeater
            FROM trisano.#{name}
                #{join_clause}
            GROUP BY 1, 2, 3
            } : %{
            SELECT
                disease_id,
                skeys(#{prefix}_repeater_hstore) AS key,
                'T'::BOOLEAN AS repeater
            FROM trisano.dw_#{prefix}_repeaters_view a
                JOIN trisano.dw_#{prefix}_events_view b
                    ON (a.dw_#{prefix}_events_id = b.id)
            GROUP BY 1, 2 }}
        ),
        dg_filtered_keys AS (
            SELECT key, repeater FROM (
                SELECT * FROM core_keys
            ) key_dis_source
            WHERE '#{dg}' = 'All tables' OR
                disease_id IN (
                    SELECT DISTINCT disease_id
                    FROM
                        trisano.avr_groups_diseases_view agd
                        JOIN trisano.avr_groups_view a
                            ON (a.name = '#{dg}' AND agd.avr_group_id = a.id)
                )
            GROUP BY 1, 2
        ),
        split_keys AS (
            SELECT
                *,
                split_part(key, '|', 1) AS form_name,
                split_part(key, '|', 2) AS question_name
            FROM dg_filtered_keys
        ),
        data_types AS (
            SELECT
                MAX(CASE WHEN q.data_type = 'date' THEN 2 ELSE 1 END) AS data_type,
                trisano.hstoresafe(q.form_short_name) AS form_name,
                trisano.hstoresafe(q.short_name) AS question_name
            FROM
                trisano.questions_view q
            GROUP BY 2, 3
        )

        SELECT
            key, form_name, question_name, repeater, data_type
        FROM
            split_keys
            JOIN data_types
                USING (form_name, question_name)
        ORDER BY form_name, question_name
        ;
    }
end

def add_formbuilder_categories(query, prefix, sourcetable, pt, bt, dg, meta, formbuilder_categories, category, category_name, conn)
    # query = the query to run to get the form and question short names for
    #         this model
    # prefix = String representing form type ('Morbidity', 'Contact', etc.)
    # pt = The PhysicalTable object associated with this hstore column
    # bt = The BusinessTable object associated with this hstore column
    # dg = The name of the disease group
    # meta = The SchemaMeta object
    # formbuilder_categories = An array of BusinessCategory objects to which
    #                          we'll append the new categories we add here
    # conn = The database connection object
    # category, category_name = Business category objects, when this is a form
    #                           field attached to a repeating core field

    # Figure out a unique, small integer associated with this prefix for use in
    # ID values.
    type_num = $event_types.fetch(prefix) { |z| $event_types[z] = $event_types.size }
    cat_was_nil = category.nil?

    last_table_name = ''
    get_query_results(query, conn).each do |fbkey|
      puts "Adding Formbuilder field : #{fbkey.inspect}" if verbose
      tablename, colname = fbkey['key'].split '|', 2
      catname = "#{prefix} #{ fbkey['repeater'] == 't' ? '*' : '' }#{tablename}"
      if cat_was_nil and (category.nil? or category_name != catname) then
        puts "Creating category '#{catname}'" if verbose
        category = BusinessCategory.new catname
        category.set_name 'en_US', catname
        category.set_root_category false
        category_name = catname
        secure category
        formbuilder_categories << category
      else
        colname = "#{tablename}:#{colname}" if !cat_was_nil
        puts "  (not creating new category #{category_name})" if verbose
      end

      #puts "#{fbkey['repeater']} #{tablename} #{colname}"
      if fbkey['repeater'] != 'f' then
        formula = "fetchval(#{prefix}_repeater_hstore, '#{fbkey['key'].gsub(/'/, "''")}'::text)"
      else
        formula = "fetchval(#{prefix}_formbuilder, '#{fbkey['key'].gsub(/'/, "''")}'::text)"
      end

      if fbkey['data_type'].to_i == 2
        formula = "trisano.format_date(#{formula})"
      end

      pc = add_single_physical_column pt, "#{tablename}_#{colname}_#{type_num}", colname, fbkey['data_type'].to_i, nil, formula
      puts "Category is nil!" if fbkey['repeater'] != 'f' and category.nil?
      bc = add_single_business_column(bt, pt, pc, "#{fbkey['key']}_#{type_num}", fbkey['key'], colname, category, 'TRUE')
    end
end

# Get formbuilder keys for repeating core fields
def core_formbuilder_query(type, group_name)
    return %{
        SELECT f.short_name AS form_short_name, q.short_name AS question_short_name
        FROM trisano.answers_view a
            JOIN trisano.questions_view q
                ON (q.id = a.question_id)
            JOIN trisano.form_elements_view fe
                ON (fe.id = q.form_element_id)
            JOIN trisano.forms_view f
                ON (f.id = fe.form_id)
            JOIN trisano.disease_events_view de
                ON (de.event_id = a.event_id)
            JOIN trisano.avr_groups_diseases_view agd
                ON (de.disease_id = agd.disease_id)
            JOIN trisano.avr_groups_view ag
                ON (ag.id = agd.avr_group_id)
        WHERE
            repeater_form_object_type = '#{type}' AND 
            ag.name = '#{group_name}'
        GROUP BY 1, 2
    }
end

def add_single_business_table(name, desc, repeat, join_clause, disease_group, dg, x, y, make_cat, formbuilder_prefix, model, meta, conn, fb_cats)
    # name = PhysicalTable name
    # desc = Friendly description users will see
    # repeat = True if this table is a repeater table
    # disease_group = Text of disease group name
    # dg = Shortened, numbered disease group identifier. These can probably be factored out
    # x, y = Pixel location of this table, used for table display in metadata editor
    # make_cat = 'TRUE' or 'FALSE', should we build business categories for this table
    # formbuilder_prefix = 'Morbidity', 'Contact', etc.; if not nil, indicates
    #                      there are formbuilder values associated with this table
    # model = BusinessModel object
    # meta = SchemaMeta object
    # conn = Database connection object
    # fb_cats = Array of formbuilder category objects

    pt = meta.find_physical_table name
    raise "Couldn't find physical table #{name}" if pt.nil?
    bt = BusinessTable.new "#{name}_#{dg}", pt
    bt.set_name 'en_US', name
    bt.set_location x, y
    secure bt

    # Build business categories, too
    if make_cat == 'TRUE'
      puts "Building business category for '#{desc}'" if verbose
      bc = BusinessCategory.new "#{desc}_#{dg}"
      bc.set_name 'en_US', desc
      bc.set_root_category false
    else
      bc = nil
    end

    add_business_columns bt, meta, bc, dg, conn
    if disease_group != 'TriSano' 
      if repeat or not formbuilder_prefix.nil? then
        query = formbuilder_hstore_query(name, formbuilder_prefix, repeat, disease_group, join_clause)
        c = nil
        cn = nil

        if (not join_clause.nil? and join_clause != '') then
            # This is a core table with repeating form fields. Find the associated core table
            c = bc
            cn = desc
        end
        add_formbuilder_categories query, formbuilder_prefix, name, pt, bt, disease_group, meta, fb_cats, c, cn, conn
      end
    end
    model.add_business_table bt
    unless bc.nil?
      secure bc
      model.get_root_category.add_business_category bc
    end

    x += 50
    if x > MaxX
      y += 120
      x = 0
    end
    return x, y
end

def add_business_tables(model, event_type, meta, disease_group, dg, conn)
  x = 0
  y = 0
  fb_cats =[]
  get_query_results(core_business_table_query(event_type), conn).each do |btrow|
    x, y = add_single_business_table btrow['physical_table_name'], btrow['table_description'], (btrow['repeat'] == '1'), btrow['join_clause'], disease_group, dg, x, y, btrow['make_category'], btrow['formbuilder_prefix'], model, meta, conn, fb_cats
  end
  fb_cats.each do |a|
    begin
      model.get_root_category.add_business_category a
    rescue NativeException
      p 'here'
    end
  end
end

def disease_group_query
  return %{
    SELECT
      DISTINCT id, name, morbidity_folder_number AS morb, assessment_folder_number AS asmt
      FROM trisano.avr_groups_view
        JOIN trisano.disease_group_numbers USING (name)
      WHERE name != 'TriSano'
      ORDER BY name DESC}
end

def disease_groups(conn)
  groups = get_query_results(disease_group_query, conn) #.map { |a| a['name'] }
  #groups <<= { 'id' => 0, 'name' => 'TriSano' }
  # This is added by dw.sql now
  #groups <<= { 'id' => 0, 'name' => 'TriSano', 'morb' => '', 'asmt' => '' }
  return groups
end

def create_models(dg, model_name_str, dg_id, event_type, meta, conn)
  puts "Processing disease group #{dg} with event type #{event_type}" if verbose
  model = BusinessModel.new model_name_str
  initialize_model model, meta
  root_bc = BusinessCategory.new
  root_bc.set_root_category true
  model.set_root_category root_bc
  add_business_tables model, event_type, meta, dg, "dg#{dg_id}", conn
  create_relationships model, "dg#{dg_id}", event_type, conn
  setup_role_security model, "dg#{dg_id}", meta, jurisdiction_hash(conn), conn
  meta.add_model(model)
end

def columns_query(tablename, schemaname)
# From Pentaho's DataTypeSettings.java:
# public static final int DATA_TYPE_STRING    = 1;
# public static final int DATA_TYPE_DATE      = 2;
# public static final int DATA_TYPE_BOOLEAN   = 3;
# public static final int DATA_TYPE_NUMERIC   = 4;
# public static final int DATA_TYPE_BINARY    = 5;
# public static final int DATA_TYPE_IMAGE     = 6;
# public static final int DATA_TYPE_URL       = 7;
    return %{
        SELECT
            column_name AS name,
            column_description AS description,
            pga.attname AS target_column,
            regexp_replace(relname || '_' || attname, '[[:space:]]', '_') AS id,
            CASE
                WHEN format_type(atttypid, atttypmod) IN ('bigint', 'integer', 'numeric') THEN 4
                WHEN format_type(atttypid, atttypmod) ~ 'timestamp' THEN 2
                WHEN format_type(atttypid, atttypmod) = 'date' THEN 2
                WHEN format_type(atttypid, atttypmod) = 'boolean' THEN 3
                WHEN format_type(atttypid, atttypmod) = 'bytea' THEN 5
                ELSE 1
            END AS data_type,
            CASE
                WHEN make_category_column THEN 'TRUE'
                ELSE 'FALSE'
            END AS make_category_column
        FROM
            trisano.core_columns c
            JOIN pg_attribute pga ON (c.target_column = pga.attname AND c.target_table::regclass = pga.attrelid)
            JOIN pg_class pgc ON (pgc.oid = pga.attrelid)
        WHERE
            relname = '#{tablename}' AND
            relnamespace = (
                SELECT oid FROM pg_namespace WHERE nspname = '#{schemaname}'
            )
        ORDER BY attnum
    }
end

def add_single_physical_column(pt, id, desc, data_type, target_column, formula)
    puts "     -- New physical column: #{id}" if verbose
    pc = PhysicalColumn.new id
    descr = (desc == '' ? id : desc)
    descr.gsub!(/^col_/, '') if pt.get_target_table =~ /^fb_/
    pc.set_name 'en_US', descr
    pc.set_description 'en_US', descr
    pc.set_data_type DataTypeSettings.new(data_type)
    pc.field_type = Java::OrgPentahoPmsSchemaConceptTypesFieldtype::FieldTypeSettings::DIMENSION
    pc.table = pt
    pc.formula = target_column
#    pc.set_relative_size -1
    pc.set_aggregation_type AggregationSettings.new(0)
    pc.set_hidden false
    if not formula.nil? then
        pc.set_formula formula
        pc.set_exact true
    end
    pt.add_physical_column pc
    return pc
end

def add_physical_columns(pt, conn)
  i = 0
  get_query_results(columns_query(pt.get_target_table, pt.get_target_schema), conn).each do |pcrow|
    i = 1
    add_single_physical_column pt, pcrow['id'], pcrow['description'], pcrow['data_type'].to_i, pcrow['target_column'], nil
  end
  raise "Didn't add any physical columns for physical table #{pt.get_target_schema}.#{pt.get_target_table}" if i == 0
end

def core_physical_table_query
  return %{
    SELECT
        table_name AS id,
        table_name AS name,
        table_description AS description,
        order_num,
        relname AS target_table,
        nspname AS target_namespace
    FROM
        trisano.core_tables
        JOIN pg_class ON (pg_class.oid = target_table::regclass)
        JOIN pg_namespace pgn ON (pgn.oid = relnamespace)
    ORDER BY order_num, name
  }
end

def add_single_physical_table(tname, tid, tdesc, ttargtable, ttargnsp, meta, conn)
    puts "Creating new physical table: #{tname}" if verbose
    pt = PhysicalTable.new tid
    pt.set_name 'en_US', tname
    pt.set_description 'en_US', tdesc
    pt.set_database_meta meta.find_database 'TriSano'
    pt.set_target_table ttargtable
    pt.set_target_schema ttargnsp
#    pt.set_relative_size -1
    pt.set_table_type TableTypeSettings.new(0)
    add_physical_columns pt, conn
    meta.add_table pt
end

def create_physical_tables(dg, meta, conn)
  get_query_results(core_physical_table_query, conn).each do |ptrow|
    add_single_physical_table ptrow['name'], ptrow['id'], ptrow['description'], ptrow['target_table'], ptrow['target_namespace'], meta, conn
  end
end

def relationships_query(event_type)
    return %{
        SELECT
            fromtab.relname || '_' || from_column AS fromcol,
            fromtab.relname AS fromtab,
            totab.relname || '_' || to_column AS tocol,
            totab.relname AS totab,
            relation_type AS type,
            join_order
        FROM
            trisano.core_relationships r
            JOIN pg_class fromtab
                ON (r.from_table::regclass = fromtab.oid)
            JOIN pg_class totab
                ON (r.to_table::regclass = totab.oid)
        WHERE 
            fromtab.relname ~ '#{event_type == 'M' ? 'dw_morbidity' : 'dw_assessment'}' OR
            totab.relname ~ '#{event_type == 'M' ? 'dw_morbidity' : 'dw_assessment'}' OR
            (
                fromtab.relname !~ '#{event_type == 'A' ? 'dw_morbidity' : 'dw_assessment'}' AND
                totab.relname !~ '#{event_type == 'A' ? 'dw_morbidity' : 'dw_assessment'}'
            )
    }
end

def create_relationships(model, dg, event_type, conn)
  get_query_results(relationships_query(event_type), conn).each do |rel|
    r = Relationship.new
    puts "Creating relationship for #{rel['fromtab']}.#{rel['fromcol']} to #{rel['totab']}.#{rel['tocol']}" if verbose
    r.table_from = model.find_business_table('en_US', rel['fromtab'])
    raise "Can't have a nil business table" if r.table_from.nil?
    r.field_from = r.table_from.find_business_column "#{rel['fromcol']}_#{dg}"
    raise "Can't have a nil from column (looked for column #{rel['fromcol']})" if r.field_from.nil?
    r.table_to = model.find_business_table('en_US', rel['totab'])
    raise "Can't have a nil business table" if r.table_to.nil?
    r.field_to = r.table_to.find_business_column "#{rel['tocol']}_#{dg}"
    raise "Can't have a nil to column (looked for column #{rel['tocol']})" if r.field_from.nil?
    r.type = rel['type']
    r.joinOrderKey = rel['join_order']
    model.add_relationship r
  end
end

def save_metadata(dg, meta, filename)
  cwm = CWM.get_instance(dg)
  CwmSchemaFactory.new.store_schema_meta(cwm, meta, nil)
  puts "Writing out new XMI file #{filename}" if verbose
  File.open(filename, 'w') do |io|
    io << cwm.getXMI
  end
  cwm.remove_domain
end

def init_etl_success(conn)
  conn.create_statement.execute_update("DELETE FROM trisano.etl_success WHERE operation = '#{OperationName}' AND NOT success");
  conn.create_statement.execute_update("INSERT INTO trisano.etl_success (success, operation) VALUES (FALSE, '#{OperationName}')");
end

def mark_etl_success(conn)
  conn.create_statement.execute_update("DELETE FROM trisano.etl_success WHERE operation = '#{OperationName}'");
  conn.create_statement.execute_update("INSERT INTO trisano.etl_success (success, operation) VALUES (TRUE, '#{OperationName}')");
end

if __FILE__ == $0
  FileUtils.rm 'metadata.xmi', :force => true
  metadatadir = File.join(server_dir, 'metadata_storage')
  FileUtils.mkdir metadatadir if (not File.exist?(metadatadir))
  metadataxmi = File.join(server_dir, 'metadata_storage', 'metadata.xmi')
  KettleEnvironment.init

  db_connection do |conn|
    init_etl_success conn
    # load plugins
    plugin_objects = []
    puts "Trying to load plugins from #{plugin_directory}" if verbose
    if File.directory?(plugin_directory) then
      Dir.glob(File.join(plugin_directory, '*')).each do |this_plugin|
        puts "Testing #{this_plugin}" if verbose
        if File.directory? File.join(this_plugin, 'avr' ) and File.exist? File.join(this_plugin, 'avr', 'build_metadata.rb') then
          require File.join(this_plugin, 'avr', 'build_metadata.rb')
          puts "Found plugin #{this_plugin}" if verbose
          # What else might I need to pass to the plugin?
          plugin_objects << TriSano_metadata_plugin.new(conn, lambda { |x, y| get_query_results(x, y) })
        end
      end
    end

    i = 1
    disease_groups(conn).each do |dg|
      %w(A M).each do |event_type|
          FileUtils.rm Dir.glob('mdr.*'), :force => true
          meta = initialize_meta SchemaMeta.new
          # Create physical tables, and all physical columns
          create_physical_tables dg['name'], meta, conn
          create_models dg['name'], "#{dg['name']}#{ event_type == 'M' ? "" : " Assessments"}", dg['id'], event_type, meta, conn
          outfile = File.join(server_dir, 'metadata_storage', "dg#{i}_#{event_type}_metadata.out")
          xmifile = File.join(server_dir, 'metadata_storage', "dg#{i}_#{event_type}_metadata.xmi")
          puts "Writing metadata for disease group '#{dg['name']}' and event type #{event_type} to #{xmifile}" if verbose
          save_metadata dg['name'], meta, outfile
          FileUtils.rm xmifile, :force => true
          FileUtils.mv(outfile, xmifile)
          FileUtils.cp(xmifile, metadataxmi)
          fnum = event_type == 'M' ? dg['morb'] : dg['asmt']
          folder = "TriSano#{fnum}"
          #folder = (dg['name'] == 'TriSano' and event_type == 'M') ? 'TriSano' : "TriSano#{i}"

          files = [Java::JavaIo::File.new(metadataxmi)].to_java(Java::JavaIo::File)
          result = PublisherUtil.publish(publish_url, folder, files, publisher_password, bi_user, bi_password, true)
          if result == PublisherUtil::FILE_ADD_SUCCESSFUL then
            puts "Successfully published metadata for disease group #{dg['name']} to '#{folder}'"
          else
            puts "ADD FAILED" if result == PublisherUtil::FILE_ADD_FAILED
            puts "PUBLISH PASSWORD INVALID" if result == PublisherUtil::FILE_ADD_INVALID_PUBLISH_PASSWORD
            puts "CREDENTIALS" if result == PublisherUtil::FILE_ADD_INVALID_USER_CREDENTIALS
            puts "FILE EXISTS" if result == PublisherUtil::FILE_EXISTS
            puts "Failed trying to publish metadata for disease group #{dg['name']} to '#{folder}'"
            begin
              FileUtils.mv(metadataxmi, File.join(server_dir, 'pentaho-solutions', folder, 'metadata.xmi'))
            rescue StandardError => err
              puts "Failed to copy metadata.xmi to #{server_dir}/pentaho-solutions/#{folder}"
              puts "**** **** **** METADATA NOT PUBLISHED! Please create the #{folder} directory in Pentaho, and re-run build_metadata."
            end
          end
        end
      i += 1 if dg['name'] != 'TriSano'
    end

    mark_etl_success conn
  end ## end of db_connection block

  # If there's a copy of metadata.xmi here, it should have been published to some
  # other directory, so remove this one.
  FileUtils.rm(metadataxmi) if File.exist?(metadataxmi)
end
