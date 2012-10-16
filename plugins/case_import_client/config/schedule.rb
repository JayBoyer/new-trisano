set :output, "#{TRISANO_LOG_LOCATION}/xsentinel_cron.log"

every 1.day, :at => '1:00am' do
   runner "CaseImportClient.start"
end
