require "rvm/capistrano"
server "ec2-184-72-206-80.compute-1.amazonaws.com", :app, :web, :db, :primary => true

#Override default deploy to location
set :deploy_to, "/opt/#{application}"

## configure the database.yml
set :database, 'trisano_production'
set :username, 'trisano_rails'
set :database_host, 'localhost'
set :rails_env, 'production' # for delayed_job
set :use_sudo, false
set :rvm_type, :user


## site config settings
set :bi_server_url               , "https://ondemand.trisano.com/pentaho-edge/Login"
set :help_url                    , "https://wiki.csinitiative.com/display/tri35/Help"
set :mailer                      , "smtp"
set :mailer_host                 , 'app.mycompany.com/trisano'
set :mailer_address              , 'smtp.mycompany.com'
set :mailer_port                 , 587
set :mailer_domain               , 'mycompany.com'
set :mailer_user_name            , 'noreply@mycompany.com'
set :mailer_password             , 'password'
set :mailer_authentication       , 'plain'
set :mailer_enable_starttls_auto , true



set :cdc_state                   , '49'

##  hl7 configuration
set :recv_facility, "CSI Dept. of TriSano, Bureau of Informatics^2.16.840.9.886571.2.99.8^ISO"
set :processing_id, "P^"

## User auth configurations
set :auth_login_timeout, 30
set :password_reset_timeout, 60 * 24 * 3
set :default_admin_uid, 'trisano_admin'
set :user_switching, false
#set :auth_src_header, 'TRISANO_UID'

## Telephone configuration
set :phone_number, '^(\d{3})-?(\d{4})$'
set :phone_number_format, '%s-%s'
set :area_code, '^(\d{3})$'
set :area_code_format, '(%s)'
set :use_area_code, true
set :extension, '^(\d{1,6})$'

# Customize to include country codes
# use_country_code: true
# country_code: "^(\d{1,3})$"
# country_code_format: "+%s"

# Configure the format of a phone number in custom forms created in formbuilder
set :form_builder_phone, '^\d{3}-\d{3}-\d{4}$'
set :form_builder_numeric, "^([0-9]*|\d*\.\d*|-[0-9]*|-\d*\.\d*)$" #Accept only positive or negative (0-9) integers and one optional decimal point.

set :session_secret_token, ""

## Locale configuration
set :locale_switching, false

before "deploy:migrate", "deploy:dump_db"
before "deploy:rollback",  "deploy:restore_db"
after "deploy:setup", "deploy:write_shared_database_yml"

namespace :deploy do
  ## Replacement database.yml updater that just links in a shared file rather than generating one
  task :update_database_yml, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end

  task :write_shared_database_yml, :roles => :app do
    require 'erb'
    require 'yaml'
    rails_env = fetch :rails_env, 'production'

    db_config = YAML::load ERB.new(IO.read("config/database.yml.sample")).result(binding)
    db_config.keys.each { |key| db_config.delete(key) unless key == rails_env }

    ask_for :database, 'Database name:'
    ask_for :username, 'Database user:'
    ask_for :database_host,     'Database host:'
    ask_for_password :database_password, 'Database password:'

    db_config[rails_env]['database'] = database
    db_config[rails_env]['username'] = username
    db_config[rails_env]['password'] = database_password
    db_config[rails_env]['host']     = database_host

    run "mkdir -p #{shared_path}/config"
    put db_config.to_yaml, "#{shared_path}/config/database.yml"
  end
end

task :test_mailer_config do
  rails_env = fetch :rails_env, 'production'
  site_config = { rails_env => generate_site_config }
  puts site_config.to_yaml
end
