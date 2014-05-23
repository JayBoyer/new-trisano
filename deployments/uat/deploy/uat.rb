require "rvm/capistrano"
server "uattwo-www.cchd.org", :app, :web, :db, :primary => true
#server "trisano-uat-www.cchd.org", :app, :web, :db, :primary => true

#Override default deploy to location
set :deploy_to, "/opt/#{application}"

## configure the database.yml
set :database, 'trisano'
set :username, 'trisano_rails'
set :database_host, 'trisano-uat-sql.cchd.org'
set :rails_env, 'uat' # for delayed_job
set :use_sudo, false
set :rvm_type, :user


## site config settings
set :bi_server_url               , "http://pentaho-dev.cchd.org:8080/pentaho/Login"
set :help_url                    , "https://wiki.csinitiative.com/display/tri35/Help"
set :mailer                      , "smtp"
## TODO Jay
#set :mailer_host                 , 'trisano-uat-www.cchd.org'
set :mailer_host                 , 'uattwo-www.cchd.org'
set :mailer_address              , 'smtp.cchd.org'
set :mailer_port                 , 25
set :mailer_domain               , 'southernnevadahealthdristrict.org'
set :mailer_user_name            , 'noreply@snhdmail.org'
set :mailer_password             , ''
set :mailer_authentication       , 'none'
set :mailer_enable_starttls_auto , true

set :cdc_state                   , '32'

##  hl7 configuration
set :recv_facility, "SNHD Trisano UAT"
set :processing_id, "P^"

## User auth configurations
set :auth_login_timeout, 90
set :password_reset_timeout, 60 * 24 * 3
set :default_admin_uid, 'trisano_admin'
set :user_switching, false

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

set :session_secret_token, "d206283860b9140987a92d189f5fe19dbbbd95aa94a52c5eca94c3094b038697e9ac0df43c2d2471731e4c55fbb88ea704dd0356d391020f24efde921271b0ff"

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
    rails_env = fetch :rails_env, 'uat'

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
  rails_env = fetch :rails_env, 'uat'
  site_config = { rails_env => generate_site_config }
  puts site_config.to_yaml
end
