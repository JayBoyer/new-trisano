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
Given /^I go to the core fields admin page$/ do
  @browser.open "/trisano/core_fields"
end

When /^I hide a core field$/ do
  element = @driver.find_element(:class, "hide")
  @test_field_href=element.attribute("href")
  element.click() 
end

Then /^the hide button should change to a display button$/ do
  @driver.execute_script( %Q{ return $j('.button a[href="#{@test_field_href}"]').first().hasClass('display'); } ).should == "true"
end

When /^I re\-display the core field$/ do
  @driver.execute_script( %Q{ $j('.button a[href="#{@test_field_href}"]').first().click(); } )
  @driver.execute_script( %Q{ $j('.button a[href="#{@test_field_href}"]').first().hasClass('hide'); } )
end

Then /^the display button should change to a hide button$/ do
  @driver.execute_script( %Q{ return $j('.button a[href="#{@test_field_href}"]').first().hasClass('hide'); } ).should == "true"
end

When /^I apply this configuration to "([^\"]*)"$/ do |disease_name|
  @other_disease = Disease.find_by_disease_name(disease_name)
  @browser.click("css=button.apply_to_diseases")  
  wait = Selenium::WebDriver::Wait.new(:timeout => 2)
  element = wait.until { @driver.find_element(:id, "other_disease_#{@other_disease.id}") }
  element.location_once_scrolled_into_view()
  element.click()
  elements = @driver.find_elements(:class, "ui-button-text")
  elements[elements.length-1].click()
  @browser.wait_for_page_to_load
end

Then /^the "([^\"]*)" disease core field is hidden$/ do |disease_name|
  found_href=false
  @disease = Disease.find_by_disease_name(disease_name)
  new_href = @test_field_href.gsub(/diseases\/\d+/, "diseases/#{@disease.id}")
  
  # we should find an element that matches our href
  elements = @driver.find_elements(:class, "display")
  elements.each do |element|
    href=element.attribute("href")
	if href == new_href
	  found_href=true
	  break
	end
  end
  found_href.should == true
end
