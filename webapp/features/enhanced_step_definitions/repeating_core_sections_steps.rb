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

Given /^a published form with repeating core fields for a (.+) event$/ do |event_type|
  disease_name = SecureRandom.hex(16)
  @form = create_form(event_type, 'Already created', 'something_published', disease_name)
  Given "that form has core field configs configured for all repeater core fields"
  @published_form = @form.publish
  @published_form.should_not be_nil, "Unable to publish form. See feature logs."
  sleep 1
end

Given /^a published form with repeating core fields for a (.+) event with matching disease$/ do |event_type|
  disease_name = @event.disease_name
  @form = create_form(event_type, 'Already created', 'something_published', disease_name)
  Given "that form has core field configs configured for all repeater core fields"
  @published_form = @form.publish
  @published_form.should_not be_nil, "Unable to publish form. See feature logs."
  sleep 1
end

Given /^that form has core field configs configured for all repeater core fields$/ do
  @core_field_container = @form.core_field_elements_container

  # Create a core field config for every core field
  CoreField.all(:conditions => ['event_type = ? and fb_accessible = true and disease_specific != true and repeater = true', @form.event_type]).each do |core_field|
    create_core_field_config(@form, @core_field_container, core_field)
  end
end


Given /^a basic (.+) event with the form's disease$/ do |event_type|
  if event_type.downcase == "encounter"
      @encounter_event = create_basic_event("encounter", get_unique_name(1), @form.diseases.first.disease_name.strip,  Place.unassigned_jurisdiction.short_name)
    @event = @encounter_event.parent_event
  elsif event_type.downcase == "contact"
      @contact_event = create_basic_event("contact", get_unique_name(1), @form.diseases.first.disease_name.strip,  Place.unassigned_jurisdiction.short_name)
    @event = @contact_event.parent_event
  else
    @event = create_basic_event(event_type, get_unique_name(1), @form.diseases.first.disease_name.strip,  Place.unassigned_jurisdiction.short_name)
  end
end

When /^I navigate to the new morbidity event page and start a event with the form's disease$/ do
  @browser.open "/trisano/cmrs/new"
  add_demographic_info(@browser, { :last_name => get_unique_name })
  @browser.type('morbidity_event_first_reported_PH_date', Date.today)
  @browser.select('morbidity_event_disease_event_attributes_disease_id', @form.diseases.first.disease_name)
end


Given /^a (.+) event with a form with repeating core fields$/ do |event_type|
  Given "a published form with repeating core fields for a #{event_type} event"
  And   "a basic #{event_type} event with the form's disease"
end

Given /^a (.+) event with a morbidity and assessment event form with repeating core fields$/ do |event_type|
  Given "a published form with repeating core fields for a morbidity_and_assessment event"
  And   "a basic #{event_type} event with the form's disease"
end

When /^I change the disease to (.+) the published form$/ do |match_not_match|
  click_core_tab(@browser, "Clinical")
  if match_not_match == "match"
    disease_name = @published_form.diseases.first.disease_name
  elsif match_not_match == "not match"
    # Don't want to use Hep B Pregnancy event because it has disease specific fields
    disease = Disease.find(:first, :conditions => ["disease_name != ? AND disease_name != ?", @published_form.diseases.first.disease_name, "Hepatitis B Pregnancy Event"])
    disease_name = disease.disease_name
  else
    raise "Unexpected syntax: #{match_not_match}"
  end
  
  if @published_form.event_type.include?("morbidity_and_assessment_event")
    key = @published_form.event_type.gsub("morbidity_and_assessment_event", @event.class.name.underscore)
  else
    key = @published_form.event_type
  end
  @browser.select("//select[@id='#{key}_disease_event_attributes_disease_id']", disease_name)
end

When /^I print the (.+) event$/ do |event_type|
  event = case event_type
            when "morbidity","assessment","morbidity and assessment"
              @event
            when "contact"
              @contact_event
            when "encounter", "place", "outbreak"
              raise "Printing is not supported for #{event_type} events."
  end

  event_path = url_for({
      :controller => event.attributes["type"].tableize,
      :id => event.id,
      :action => :show,
      :format => "print",
      :commit => "Print",
      "print_options[]" => "All",
      :only_path => true
    })
  @browser.open "/trisano" + event_path
end

When /^I fill in "(.+)" with an invalid date$/ do |label|
  invalid_date = 1.year.from_now.to_date.to_formatted_s
  When "I fill in \"#{label}\" with \"#{invalid_date}\""
end

When /^I fill in "(.+)" with a valid date$/ do |label|
  valid_date = 1.day.ago.to_date.to_formatted_s
  When "I fill in \"#{label}\" with \"#{valid_date}\""
end

When /^the (.+) tab should be highlighted in red$/ do |tab|
  @browser.get_xpath_count("//a[@href='##{tab.downcase}_tab'][contains(@style,'color: red')]").should be_equal(1), "Expected #{tab} to be highlighted in red."
end

Given /^I have required repeater core field prerequisites$/ do
  And "a lab named \"Acme Lab\""
  And "a lab named \"LabCo Lab\""
  And "a lab test type named \"TriCorder\""
  And "a lab test type named \"CAT Scan\""
end

When /^I navigate to the form's builder page$/ do
  @browser.open "/trisano" + builder_path(@form)
end

Then /^I should see (\d+) instances of the repeater core field config questions$/ do |expected_count|
  # We want to use body_text here because the JavaScript links contain template code
  # which have the question text in them, which throws off the count...not that we want to 
  # count templates anyway.
  @core_fields ||= CoreField.all(:conditions => ['event_type = ? AND fb_accessible = ? AND disease_specific = ? AND repeater = ?', @form.event_type, true, false, true])
  @core_fields.count.should_not be_equal(0), "Didn't find any lab core fields."
  @core_fields.each do |core_field|
    if core_field.key.include?("morbidity_and_assessment_event")
      key = core_field.key.gsub("morbidity_and_assessment_event", @event.class.name.underscore)
    else
      key = core_field.key
    end
	
	counts = Array.new(2, 0)
	suffixes = [ "#{key} before?", "#{key} after?"]
	(0..1).each do |i|
	  text = suffixes[i]
	  elements = @driver.find_elements(:xpath, "//label[contains(text(),'#{text}')]")	  
	  counts[i] += elements.count
	  elements = @driver.find_elements(:xpath, "//span[contains(text(),'#{text}')]")	  
	  counts[i] += elements.count
	end

    counts[0].should be_equal(expected_count.to_i), "Expected #{expected_count} instances of before question for #{key}, got #{counts[0]}." 
    counts[1].should be_equal(expected_count.to_i), "Expected #{expected_count} instances of after question for #{key}, got #{counts[1]}." 
  end
end

Then /^I should see (\d+) instances of answers to the repeating core field config questions$/ do |expected_count|
  html_source = @driver.page_source()
  @core_fields ||= CoreField.all(:conditions => ['event_type = ? AND fb_accessible = ? AND disease_specific = ? AND repeater = ?', @form.event_type, true, false, true])
  @core_fields.count.should_not be_equal(0), "Didn't find any core fields."
  @core_fields.each do |core_field|
    if core_field.key.include?("morbidity_and_assessment_event")
      key = core_field.key.gsub("morbidity_and_assessment_event", @event.class.name.underscore)
    else
      key = core_field.key
    end
    expected_count.to_i.times do |i|
      before_count = html_source.scan("#{key} before answer #{i}").count
      before_count.should be_equal(1), "Expected 1 instance of '#{key} before answer #{i}', got #{before_count}." 

      after_count = html_source.scan("#{key} after answer #{i}").count
      after_count.should be_equal(1), "Expected 1 instance of '#{key} after answer #{i}', got #{after_count}." 
    end
  end
end

When /^I create (\d+) new instances of all (.+) event repeaters$/ do |count, event_type|
    count.to_i.times do
     
     unless event_type == "encounter"
        click_core_tab(@browser, "Demographics")
        And  "I click the \"Add a Telephone\" link and don't wait"
        And  "I click the \"Add an Email Address\" link and don't wait"
      end

      click_core_tab(@browser, "Clinical")
      unless event_type == "encounter"
        And  "I click the \"Add a Hospitalization Facility\" link and don't wait"
      end
      And  "I click the \"Add a Treatment\" link and don't wait"
    
      When "I enter the following lab results for the \"Acme Lab\" lab:", table([
              %w(test_type),
              %w(TriCorder),
              ["CAT Scan"]])
    end
end

When /^I answer (\d+) instances of all repeater questions$/ do |count|
  html_source = @driver.page_source()
  @core_fields ||= CoreField.all(:conditions => ['event_type = ? AND fb_accessible = ? AND disease_specific = ? AND repeater = ?', @form.event_type, true, false, true])
  raise "No core fields found" if @core_fields.empty?
  @core_fields.each do |core_field|
    if core_field.key.include?("morbidity_and_assessment_event")
      key = core_field.key.gsub("morbidity_and_assessment_event", @event.class.name.underscore)
    else
      key = core_field.key
    end
    count.to_i.times do |i|
      answer_investigator_question(@browser, "#{key} before?", "#{key} before answer #{i}", html_source, i)
      answer_investigator_question(@browser, "#{key} after?", "#{key} after answer #{i}", html_source, i)
    end
  end
end

When /^I answer (\d+) instances of all repeater section questions$/ do |count|
  html_source = @driver.page_source()
  count.to_i.times do |i|
    answer_investigator_question(@browser, "#{@first_section_name} question?", "#{@first_section_name} answer #{i}", html_source, i)
    answer_investigator_question(@browser, "#{@second_section_name} question?", "#{@second_section_name} answer #{i}", html_source, i)
  end
end

When /^I create (\d+) new instances of all section repeaters$/ do |count|
  count.to_i.times do
    And  "I click the \"Add another #{@first_section_name} section\" link and don't wait"
    And  "I click the \"Add another #{@second_section_name} section\" link and don't wait"
  end
end

Then /^I should see (\d+) instances of the repeater section questions$/ do |expected_count|
  @first_section_name.should_not be_nil, "First section name not defined."
  @second_section_name.should_not be_nil, "Second section name not defined."
  html_source = @driver.page_source()
  actual_count = html_source.scan("#{@first_section_name} question?").count
  actual_count.should be_equal(expected_count.to_i), "Expected #{expected_count} instances of '#{@first_section_name} question?', got #{actual_count}." 
  actual_count = html_source.scan("#{@second_section_name} question?").count
  actual_count.should be_equal(expected_count.to_i), "Expected #{expected_count} instances of '#{@second_section_name} question?', got #{actual_count}." 
end

Then /^I should see (\d+) instances of the repeater section questions in body text$/ do |expected_count|
  @first_section_name.should_not be_nil, "First section name not defined."
  @second_section_name.should_not be_nil, "Second section name not defined."
  # We want to use body_text here because the JavaScript links contain template code
  # which have the question text in them, which throws off the count...not that we want to 
  # count templates anyway.
#  html_source = @driver.page_source()
  html_source = @driver.find_element(:tag_name, "body").text
  actual_count = html_source.scan("#{@first_section_name} question?").count
  actual_count.should be_equal(expected_count.to_i), "Expected #{expected_count} instances of '#{@first_section_name} question?', got #{actual_count}." 
  actual_count = html_source.scan("#{@second_section_name} question?").count
  actual_count.should be_equal(expected_count.to_i), "Expected #{expected_count} instances of '#{@second_section_name} question?', got #{actual_count}." 
end

Then /^I should see (\d+) instances of answers to the repeating section questions$/ do |count|
  @first_section_name.should_not be_nil, "First section name not defined."
  @second_section_name.should_not be_nil, "Second section name not defined."

  html_source = @driver.page_source()
  count.to_i.times do |i|
    actual_count = html_source.scan("#{@first_section_name} answer #{i}").count
    actual_count.should be_equal(1), "Expected 1 instances of '#{@first_section_name} answer #{i}', got #{actual_count}."
    actual_count = html_source.scan("#{@second_section_name} answer #{i}").count
    actual_count.should be_equal(1), "Expected 1 instances of '#{@second_section_name} answer #{i}', got #{actual_count}."
  end
end

When /^I mark all section repeaters for removal$/ do
  event = @contact_event || @place_event || @encounter_event || @event
  event.investigator_form_sections.count.times do |i|
    @browser.check "xpath=(//input[contains(@id, '_investigator_form_sections_attributes_')][contains(@id, '__destroy')])[#{i+1}]"
  end
end

When /^I mark all core repeaters for removal$/ do
  event = @contact_event || @place_event || @encounter_event || @event
  event.interested_party.person_entity.telephones.count.times do |i|
    @browser.check "xpath=(//input[contains(@id, '_interested_party_attributes_person_entity_attributes_telephones_attributes_')][contains(@id, '__destroy')])[#{i+1}]"
  end
  event.interested_party.person_entity.email_addresses.count.times do |i|
    @browser.check "xpath=(//input[contains(@id, '_interested_party_attributes_person_entity_attributes_email_addresses_attributes_')][contains(@id, '__destroy')])[#{i+1}]"
  end
  click_core_tab(@browser, CLINICAL)
  event.hospitalization_facilities.count.times do |i|
    @browser.check "xpath=(//input[contains(@id, '_hospitalization_facilities_attributes_')][contains(@id, '__destroy')])[#{i+1}]"
  end
  event.interested_party.treatments.count.times do |i|
    @browser.check "xpath=(//input[contains(@id, '_interested_party_attributes_treatments_attributes_')][contains(@id, '__destroy')])[#{i+1}]"
  end
  click_core_tab(@browser, LABORATORY)
  event.lab_results.count.times do |i|
    @browser.check "xpath=(//input[contains(@id, '_lab_results_attributes_')][contains(@id, '__destroy')])[#{i+1}]"
  end
end

Then /^the database should have (\d+) answers and investigator form questions for this event$/ do |expected_count|
  event = @contact_event || @place_event || @encounter_event || @event
  answer_count = event.answers.count
  answer_count.should be_equal(expected_count.to_i), "Expected #{expected_count} answers, got #{answer_count}."

  investigator_form_sections_count = event.investigator_form_sections.count
  investigator_form_sections_count.should be_equal(expected_count.to_i), "Expected #{expected_count} investigator form questions, got #{investigator_form_sections_count}."
end

Given /^that form has two repeating sections configured in the default view with a question$/ do
  Given "that form has a repeating section configured in the default view with a question"
  @first_section_name = @section_element.name
  Given "that form has a repeating section configured in the default view with a question"
  @second_section_name = @section_element.name
end

Given /^that form has a repeating section configured in the default view with a question$/ do
  @default_view = @form.investigator_view_elements_container.children[0]
  @section_element = SectionElement.new
  @section_element.parent_element_id = @default_view.id
  @section_element.name = get_random_word 
  @section_element.repeater = true
  @section_element.save_and_add_to_form

  create_question_on_form(@form, { :question_text => "#{@section_element.name} question?", :short_name => Digest::MD5::hexdigest(@section_element.name) }, @section_element)
end
