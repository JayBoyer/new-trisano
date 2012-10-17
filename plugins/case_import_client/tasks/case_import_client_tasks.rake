namespace :whenever do
  desc "Update whenever crontab"
  task "xsentinel:update" => :environment do
    `whenever -f #{RAILS_ROOT}/vendor/trisano/case_import_client/config/schedule.rb --update-crontab xsentinel`
  end

  desc "Run XSentinel job"
  task "xsentinel:run" => :environment do
    CaseImportClient.start_import
  end
end