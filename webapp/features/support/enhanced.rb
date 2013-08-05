# Copyright (C) 2007, 2008, 2009, 2010, 2011, 2012, 2013 The Collaborative Software Foundation
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

Webrat.configure do |config|
  config.mode = :selenium
  # Selenium defaults to using the selenium environment. Use the following to override this.
  # config.application_environment = :test
end

require 'database_cleaner'

# Adding our patched-in do-nothing strategy to the list of available strategies.
#
# See lib/database_cleaner/active_record/nothing.rb
#
# Getting around this: http://github.com/aslakhellesoy/cucumber-rails/issues/issue/9
DatabaseCleaner::ActiveRecord.class_eval do
  def self.available_strategies
    %w[truncation transaction nothing]
  end
end

DatabaseCleaner.strategy = :nothing
Cucumber::Rails::World.use_transactional_fixtures = false

require 'spec/expectations'
require 'selenium/webdriver'
require 'selenium/client'
require 'selenium/server'

# "before all"
  jar_name = "#{RAILS_ROOT}/features/support/selenium/selenium-server-standalone-2.33.0.jar"
  server = Selenium::Server.new(jar_name, :background => true)
  server.start
  browser = Selenium::Client::Driver.new :host  => "localhost",
                                         :port  => 4444,
                                         :url   => "http://localhost:8080",
                                         :browser => "*webdriver"
  driver = Selenium::WebDriver.for :remote, :url => "http://localhost:4444/wd/hub/"
  browser.start :driver => driver
 
# Allow profiling of cucumber features
if ENV['RUBY_PROF'].present?
  require 'ruby-prof'
  RubyProf.start

  at_exit do
    results = RubyProf.stop
    puts ARGV.inspect
    File.open "tmp/cucumber_#{Time.now}", 'w' do |file|
      RubyProf::CallTreePrinter.new(results).print(file)
    end
  end 

end
Before do
  @browser = browser
  @driver = driver
  
  @browser.open "http://localhost:8080/trisano/events"
end

After do
end

# "after all"
at_exit do

# comment out the following 2 lines to leave the browser up at the end of the tests
  browser.stop
  server.stop
end
