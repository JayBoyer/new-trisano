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

When(/^I navigate to the new morbidity event page and start a simple event$/) do
  @browser.open "/trisano/cmrs/new"
  add_demographic_info(@browser, { :last_name => get_unique_name })
  @browser.type('morbidity_event_first_reported_PH_date', Date.today)
end

When(/^I navigate to the new assessment event page and start a simple event$/) do
  @browser.open "/trisano/aes/new"
  add_demographic_info(@browser, { :last_name => get_unique_name })
  @browser.type('assessment_event_first_reported_PH_date', Date.today)
end

When /^I go to the new CMR page$/ do
  @browser.open "/trisano/cmrs/new"
  wait_for_element_present(:text, "New CMR", 10) 
end

When(/^I navigate to the morbidity event edit page$/) do
  @browser.click "link=EVENTS"
  wait_for_element_present(:text, "Change View", 10) 
  @browser.click "link=Edit"
  wait_for_element_present(:text, "Edit morbidity event", 10) 
end

When(/^I navigate to the assessment event edit page$/) do
  @browser.click "link=EVENTS"
  wait_for_element_present(:text, "Change View", 10)
  @browser.click "link=Edit"
  wait_for_element_present(:text, "Edit assessment event", 10)
end

When(/^I am on the assessment event edit page$/) do
  @browser.open "/trisano/aes/#{(@event).id}/edit"
  wait_for_element_present(:id, "disable_tabs", 5)
end

When(/^I am on the morbidity event edit page$/) do
  @browser.open "/trisano/cmrs/#{(@event).id}/edit"
  wait_for_element_present(:id, "disable_tabs", 5)
end

When(/^I am on the morbidity event show page$/) do
  @browser.open "/trisano/cmrs/#{(@event).id}"
  wait_for_element_present(:id, "disable_tabs", 5)
end

# Consider refactoring the name of this one -- it really isn't
# navigating, it's more like a "when I am on" -- doesn't 'I am on'
# imply a verification that you are already there?
When(/^I navigate to the morbidity event show page$/) do
  @browser.open "/trisano/cmrs/#{(@event).id}"
  wait_for_element_present(:id, "disable_tabs", 5)
end

When(/^I navigate to the assessment event show page$/) do
  @browser.open "/trisano/aes/#{(@event).id}"
  wait_for_element_present(:text, "View Assessment Event", 10)
end

When /^I am on the events index page$/ do
  @browser.open "/trisano/events"
  wait_for_element_present(:text, "Events", 10)
end

When(/^I am on the contact event edit page$/) do
  @browser.open "/trisano/contact_events/#{@contact_event.id}/edit"
  wait_for_element_present(:text, "Edit Contact event", 10)
end

When /^I navigate to the contact event edit page$/ do
  When "I am on the contact event edit page"
  wait_for_element_present(:text, "Edit Contact event", 10)
end

When /^I navigate to the encounter event edit page$/ do
  @browser.open "/trisano/encounter_events/#{(@encounter_event).id}/edit"
  wait_for_element_present(:text, "Edit Encounter Event", 10)
end

When /^I am on the encounter event edit page$/ do
  When "I navigate to the encounter event edit page"
  wait_for_element_present(:text, "Edit Encounter Event", 10)
end

When /^I navigate to the contact named "(.+)"$/ do |last_name|
  @contact_event = ContactEvent.first(:include => { :interested_party => { :person_entity => :person } },
                                      :conditions => ['people.last_name = ?', last_name])
  @browser.open "/trisano/contact_events/#{@contact_event.id}/edit"
  wait_for_element_present(:text, "Edit Contact event", 10)
end

When /^I select "([^\"]*)" from the sibling navigator$/ do |option_text|
  @browser.select "css=.events_nav", option_text
end

When /^I select "([^\"]*)" from the sibling navigator and Save$/ do |option_text|
  @browser.select "css=.events_nav", option_text
  wait = Selenium::WebDriver::Wait.new(:timeout => 3)
  element = wait.until { @driver.find_element(:xpath, "//button/span[contains(text(), 'Save')]") }
  element.click()
end

When /^I select "([^\"]*)" from the sibling navigator and leave without saving$/ do |option_text|
  @browser.select "css=.events_nav", option_text
  wait = Selenium::WebDriver::Wait.new(:timeout => 3)
  element = wait.until { @driver.find_element(:xpath, "//button/span[contains(text(), 'Leave')]") }
  element.click()
end

When /^I select "([^\"]*)" from the sibling navigator but cancel the dialog$/ do |option_text|
  @browser.select "css=.events_nav", option_text
  wait = Selenium::WebDriver::Wait.new(:timeout => 3)
  element = wait.until { @driver.find_element(:xpath, "//a/span[contains(text(), 'close')]") }
  element.click()
end

Then /^I should be on the contact named "([^\"]*)"$/ do |last_name|
  @contact_event = ContactEvent.first(:include => { :interested_party => { :person_entity => :person } },
                                      :conditions => ['people.last_name = ?', last_name])
  @browser.get_location.should =~ /trisano\/contact_events\/#{@contact_event.id}\/edit/
end

When /^I enter "([^\"]*)" as the contact\'s first name$/ do |text|
  @browser.type("css=#contact_event_interested_party_attributes_person_entity_attributes_person_attributes_first_name",
                text)
end

Then /^no value should be selected in the sibling navigator$/ do
  script = "return $j('.events_nav').val();"
  @driver.execute_script(script).should == ""
end

When(/^I am on the place event edit page$/) do
  @browser.open "/trisano/place_events/#{(@place_event).id}/edit"
  wait_for_element_present(:text, "Edit Place", 10)
end

When /^I save and continue$/ do
  element = @driver.find_element(:id, "save_and_continue_btn")
  element.click()
  wait_for_text_or_text("was successfully", "prohibited")
end

When /^I save and exit$/ do
  element = @driver.find_element(:id, "save_and_exit_btn")
  element.click()
  wait_for_text_or_text("was successfully", "prohibited")
end

Then /^events list should show (\d+) events$/ do |expected_count|
  @browser.get_xpath_count("//div[@class='patientname']").should == expected_count
end

Given /^a clean events table$/ do
  Address.destroy_all
  ParticipationsRiskFactor.destroy_all
  Participation.destroy_all
  Task.destroy_all
  Event.destroy_all
end

After('@clean_events') do
  Address.all.each(&:delete)
  ParticipationsRiskFactor.destroy_all
  Participation.destroy_all
  Task.destroy_all
  Event.all.each(&:delete)
end

When /^I scroll down a bit$/ do
  script =  "$j('html,body').animate({scrollTop: 300},'fast');"
  @driver.execute_script(script)
end

Then /^I should have been scrolled back to the top of the page$/ do
  script = "return $j('html,body').scrollTop();"
  @driver.execute_script(script).should == 0
end

Then /^I should have a note that says "([^\"]*)"$/ do |text|
  @browser.get_xpath_count("//div[@id='existing-notes']//p[contains(text(), '#{text}')]").to_i.should >= 1
end

When /^I enter a valid first reported to public health date$/ do
  @browser.type('morbidity_event_first_reported_PH_date', Date.today)
end

When /^I enter basic CMR data$/ do
  @browser.type 'morbidity_event_interested_party_attributes_person_entity_attributes_person_attributes_last_name', 'Smoker'
  When %{I enter a valid first reported to public health date}
end
