# Copyright (C) 2007, 2008, The Collaborative Software Foundation
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

require File.dirname(__FILE__) + '/spec_helper'

# $dont_kill_browser = true

describe 'Adding multiple hospitals to a CMR' do
  
  it "should allow adding new hospitals to a new CMR" do
    @browser.open "/trisano/cmrs"
    click_nav_new_cmr(@browser)
    @browser.type "morbidity_event_active_patient__active_primary_entity__person_last_name", "Hospital-HF"
    @browser.type "morbidity_event_active_patient__active_primary_entity__person_first_name", "Johnny"

    click_core_tab(@browser, "Clinical")
    @browser.click "link=Add a hospital"
    sleep(1)
    @browser.select "//div[@class='hospital'][1]//select", "label=Allen Memorial Hospital"
    @browser.select "//div[@class='hospital'][2]//select", "label=Gunnison Valley Hospital"

    save_cmr(@browser).should be_true

    @browser.is_text_present('CMR was successfully created.').should be_true
    @browser.is_text_present('Allen Memorial Hospital').should be_true
    @browser.is_text_present('Gunnison Valley Hospital').should be_true
  end

  it "should allow removing a hospital" do
    edit_cmr(@browser)
    click_core_tab(@browser, "Clinical")
    @browser.click "remove_hospital_result_link"
    @browser.click "morbidity_event_submit"
    sleep(3)
    @browser.is_text_present('Allen Memorial Hospital').should_not be_true
  end

  it "should allow editing a hospital" do
    edit_cmr(@browser)
    click_core_tab(@browser, "Clinical")
    @browser.select("//div[@class='hospital']//select", "label=Alta View Hospital")
    @browser.click "morbidity_event_submit"
    sleep(3)
    @browser.is_text_present('Alta View Hospital').should be_true
  end

end
