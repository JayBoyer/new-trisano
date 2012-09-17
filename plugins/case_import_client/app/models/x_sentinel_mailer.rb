class XSentinelMailer < ActionMailer::Base
  reloadable!
  def daily_export_completed(date, cases, status)
    recipients  config_option(:xsentinel_notification_email)
    subject     "X-Sentinel Daily Export #{date.to_s}"
    from "MARC notifications <csi@endpoint.com>"
    body        :status => status, :date => date, :cases => cases
    template "daily_export_completed.html.haml"
  end
end
