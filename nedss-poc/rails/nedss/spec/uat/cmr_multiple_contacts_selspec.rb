require File.dirname(__FILE__) + '/spec_helper'

describe 'Adding multiple contacts to a CMR' do
  
  # $dont_kill_browser = true
  
  before(:all) do
    @original_last_name = get_unique_name(2) + " mc"
    @edited_last_name = get_unique_name(2) + " mc"
    @new_last_name = get_unique_name(2) + " mc"
  end
  
  after(:all) do
    @original_last_name = nil
    @edited_last_name = nil
    @new_last_name = nil
  end
  
  it "should allow a single contact to be saved with a new CMR" do
    @browser.open "/nedss/cmrs"
    click_nav_new_cmr(@browser).should be_true
    @browser.type "morbidity_event_active_patient__active_primary_entity__person_last_name", "multi-contact"
    @browser.type "morbidity_event_active_patient__active_primary_entity__person_first_name", "test"
    @browser.select "morbidity_event_disease_disease_id", "label=AIDS"
    @browser.select "morbidity_event_active_jurisdiction_secondary_entity_id", "label=Davis County Health Department"

    click_core_tab(@browser, "Contacts")
    @browser.type "morbidity_event_contact__active_secondary_entity__person_last_name", @original_last_name
    @browser.type "morbidity_event_contact__active_secondary_entity__person_first_name", "multi-contact"
    @browser.type "morbidity_event_contact__active_secondary_entity__address_street_number", "123"
    @browser.type "morbidity_event_contact__active_secondary_entity__address_street_name", "Main St."
    @browser.type "morbidity_event_contact__active_secondary_entity__telephone_area_code", "212"
    @browser.type "morbidity_event_contact__active_secondary_entity__telephone_phone_number", "5551212"
    save_cmr(@browser).should be_true
    @browser.is_text_present(@original_last_name).should be_true
  end

  it "should allow editing a contact from the CMR's show mode" do
    click_core_tab(@browser, "Contacts")
    @browser.click "link=Edit contact"
    sleep(3)
    # @browser.wait_for_element_present("person_form")
    @browser.type "entity_person_last_name", @edited_last_name
    @browser.click "person-save-button"
    sleep(3)
    # @browser.wait_for_element_not_present("person_form")
    @browser.is_text_present(@edited_last_name).should be_true
    @browser.is_text_present(@original_last_name).should be_false
  end
  
  it "should allow editing a contact from the CMR's edit mode, changing last name back to the original version" do
    edit_cmr(@browser).should be_true
    click_core_tab(@browser, "Contacts")
    @browser.click "link=Edit contact"
    sleep(3)
    # @browser.wait_for_element_present("person_form")
    @browser.type "entity_person_last_name", @original_last_name
    @browser.click "person-save-button"
    sleep(3)
    # @browser.wait_for_element_not_present("person_form")
    @browser.is_text_present(@edited_last_name).should be_false
    @browser.is_text_present(@original_last_name).should be_true
  end
  
  it "should allow adding a contact from the CMR's edit mode" do
    @browser.click "link=New Contact"
    sleep(3)
    # @browser.wait_for_element_present("person_form")
    @browser.type "entity_person_last_name", @new_last_name
    @browser.click "person-save-button"
    sleep(3)
    # @browser.wait_for_element_not_present("person_form")
    @browser.is_text_present(@new_last_name).should be_true
    @browser.is_text_present(@original_last_name).should be_true
  end

  it "should allow for showing of contact information" do
    click_core_tab(@browser, "Contacts")
    click_link_by_order(@browser, "show-contact", 2)
    sleep(3)
    @browser.is_text_present("Showing contacts").should be_true
    @browser.is_text_present("123").should be_true
    @browser.is_text_present("Main St.").should be_true
    @browser.is_text_present("212").should be_true
    @browser.is_text_present("555-1212").should be_true
    @browser.click "link=Close"
  end

  it "shold allow a contact to made into a CMR" do
    click_link_by_order(@browser, "start-contact-cmr-link", 2)
    sleep(3)
    @browser.is_text_present("Edit contact's CMR").should be_true
    @browser.click "link=Edit contact's CMR"
    @browser.wait_for_page_to_load($load_time)
    @browser.get_value("morbidity_event_active_patient__active_primary_entity__person_last_name").should == @original_last_name
    @browser.get_value("morbidity_event_active_patient__active_primary_entity__person_first_name").should == "multi-contact"
    @browser.get_value("morbidity_event_active_patient__active_primary_entity__address_street_number").should == "123"
    @browser.get_value("morbidity_event_active_patient__active_primary_entity__address_street_name").should == "Main St."
    @browser.get_value("morbidity_event_active_patient__active_primary_entity__telephone_area_code").should == "212"
    @browser.get_value("morbidity_event_active_patient__active_primary_entity__telephone_phone_number").should == "5551212"
    @browser.get_selected_label("morbidity_event_disease_disease_id").should == "AIDS"
    @browser.get_selected_label("morbidity_event_active_jurisdiction_secondary_entity_id").should == "Davis County Health Department"
    @browser.get_selected_label("morbidity_event_active_jurisdiction_secondary_entity_id").should == "Davis County Health Department"
    @browser.get_selected_label("morbidity_event_udoh_case_status_id").should == "Suspect"
  end
end
