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

module TrisanoAdminHelper

  # CDC Helpers

  def navigate_to_export_admin(browser)
    browser.open "/trisano/events"
    click_nav_admin(browser)
    browser.click("admin_cdc_config")
    wait_for_element_present(:text, "Export Columns")
    return(browser.is_text_present("Export Columns"))
  end

  # Disease Admin Helpers

  def navigate_to_disease_admin(browser)
    browser.open "/trisano/events"
    click_nav_admin(browser)
    browser.click("admin_diseases")
    wait_for_element_present(:text, "Diseases")
    return(browser.is_text_present("Diseases"))
  end

  def create_disease(browser, disease_attributes)
    modify_disease(browser, disease_attributes)
    wait_for_element_present(:text, "Disease was successfully created.")
    return(browser.is_text_present("Disease was successfully created."))
  end

  def modify_disease(browser, disease_attributes)
    browser.type("disease_disease_name", disease_attributes[:disease_name]) if disease_attributes[:disease_name]
    browser.type("disease_cdc_code", disease_attributes[:cdc_code]) if disease_attributes[:cdc_code]
    browser.click("disease_active") if disease_attributes[:disease_active]
    browser.type("disease_contact_lead_in", disease_attributes[:contact_lead_in]) if disease_attributes[:contact_lead_in]
    browser.type("disease_place_lead_in", disease_attributes[:place_lead_in]) if disease_attributes[:place_lead_in]
    browser.type("disease_treatment_lead_in", disease_attributes[:treatment_lead_in]) if disease_attributes[:treatment_lead_in]
    if disease_attributes[:external_codes]
      disease_attributes[:external_codes].each do |id, msg|
        browser.send(msg, [id])
      end
    end
    browser.click("disease_submit")
  end

  def click_edit_disease(browser, disease_name)
    disease_id = get_resource_id(browser, disease_name)
    browser.click("//a[contains(@href, 'diseases/#{disease_id}/edit')]")
    wait_for_element_present(:text, "Edit disease")
  end

  def edit_disease(browser, disease_name, disease_attributes)
    click_edit_disease(browser, disease_name)
    modify_disease(browser, disease_attributes)
    wait_for_element_present(:text, "Disease was successfully updated.")
    return(browser.is_text_present("Disease was successfully updated."))
  end

  # User Admin Helpers

  def navigate_to_user_admin(browser)
    browser.open "/trisano/events"
    click_nav_admin(browser)
    browser.click("link=Manage Users")
    wait_for_element_present(:text, "Users")
    return(browser.is_text_present("Users"))
  end
  
  def add_role(browser, role_attributes, index = 1)
    browser.click "link=Add Role"
	wait = Selenium::WebDriver::Wait.new(:timeout => 5)
    element = wait.until { @driver.find_element(:id, "user_role_membership_attributes__jurisdiction_id") }
    browser.select "user_role_membership_attributes__role_id", "label=#{role_attributes[:role]}"
    browser.select "user_role_membership_attributes__jurisdiction_id", "label=#{role_attributes[:jurisdiction]}"
  end

  # Entity management helpers

  def navigate_to_place_admin(browser)
    browser.open "/trisano/events"
    click_nav_admin(browser)
    browser.click("admin_places")
    wait_for_element_present(:text, "Place management")
    return(browser.is_text_present("Place Management"))
  end

  
end
