require File.dirname(__FILE__) + '/spec_helper'

describe 'Adding multiple diagnosing health facilities to a CMR' do
  
  # $dont_kill_browser = true
  
  it "should allow a single diagnosing health facility to be saved with a new CMR" do
    @browser.open "/nedss/cmrs"
    @browser.click "link=New CMR"
    @browser.wait_for_page_to_load($load_time)
    @browser.type "event_active_patient__active_primary_entity__person_last_name", "Diagnosing-HF"
    @browser.type "event_active_patient__active_primary_entity__person_first_name", "Johnny"
    click_core_tab(@browser, "Clinical")
    @browser.select "event_diagnosing_health_facility_secondary_entity_id", "label=Ogden Regional Medical Center"
    @browser.click "event_submit"
    @browser.wait_for_page_to_load($load_time)
    @browser.is_text_present('CMR was successfully created.').should be_true
    @browser.is_text_present('Diagnosing-HF').should be_true
    @browser.is_text_present('Ogden Regional Medical Center').should be_true
  end

  it "should allow editing a diagnosing health facility from the CMR's show mode" do
    click_core_tab(@browser, "Clinical")
    @browser.click "link=Edit health facility"
    sleep(3)
    # @browser.wait_for_element_present("health_facility_form")
    @browser.select "health_facility_secondary_entity_id", "label=Gunnison Valley Hospital"
    @browser.click "health-facility-save-button"
    sleep(3)
    # @browser.wait_for_element_not_present("health_facility_form")
    @browser.is_text_present('Gunnison Valley Hospital').should be_true
  end

  it "should allow editing a diagnosing health facility from the CMR's edit mode" do
    @browser.click "edit_cmr_link"
    @browser.wait_for_page_to_load($load_time)
    click_core_tab(@browser, "Clinical")
    @browser.click "link=Edit health facility"
    sleep(3)
    # @browser.wait_for_element_present("health_facility_form")
    @browser.select "health_facility_secondary_entity_id", "label=Ogden Regional Medical Center"
    @browser.click "health-facility-save-button"
    sleep(3)
    # @browser.wait_for_element_not_present("health_facility_form")
    @browser.is_text_present('Ogden Regional Medical Center').should be_true
  end

  it "should allow adding a diagnosing health facility from the CMR's edit mode" do
    click_link_by_order(@browser, "new-health-facility", 1)
    sleep(3)
    # @browser.wait_for_element_present("health_facility_form")
    @browser.select "health_facility_secondary_entity_id", "label=Gunnison Valley Hospital"
    @browser.click "health-facility-save-button"
    sleep(3)
    # @browser.wait_for_element_not_present("health_facility_form")
    @browser.is_text_present('Gunnison Valley Hospital').should be_true
  end 
  
end
