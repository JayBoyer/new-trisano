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

require File.dirname(__FILE__) + '/spec_helper'

describe 'CMR pagination' do

  def create_and_route_cmr
    create_simplest_cmr(@browser, get_unique_name(1))
    @browser.click "link=Route to Local Health Depts."
    @browser.get_selected_label('jurisdiction_id').should == "Unassigned"
    @browser.select "jurisdiction_id", "label=Central Utah"
    @browser.click "route_event_btn"
    wait_for_element_present(:text, "Event successfully routed")
    @browser.get_selected_label('jurisdiction_id').should == "Central Utah"
    @browser.click("accept_accept")
    wait_for_element_present(:text, "Accepted by Local Health Dept.")
    @browser.is_text_present("Accepted by Local Health Dept.").should be_true
    @browser.is_text_present('Route to').should be_true
    @browser.select "morbidity_event__event_queue_id", "label=#{@queue_name}-UtahCounty"
    wait_for_element_present(:text, "Assign to investigator")
  end

  before :all do
    # need a queue so pagination rules not impacted by other specs
    @queue_name = ('pagination' + get_unique_name(2)).gsub(' ', '').capitalize
  end

  it 'should first create a special queue' do
    @browser.open "/trisano/admin"
    current_user = @browser.get_selected_label("user_id")
    if current_user != "default_user"
      switch_user(@driver, "default_user")
    end

    @browser.click "admin_queues"
    wait_for_element_present(:text, "Event Queues")
    
    @browser.click "create_event_queue"
    wait_for_element_present(:text, "Create event queue")

    @browser.type "event_queue_queue_name", @queue_name
    @browser.select "event_queue_jurisdiction_id", "label=Utah County Health Department"

    @browser.click "event_queue_submit"
    wait_for_element_present(:text, "Event queue was successfully created.")

    @browser.is_text_present('Event queue was successfully created.').should be_true
    @browser.is_text_present(@queue_name).should be_true
    @browser.is_text_present('Utah County Health Department').should be_true
  end

  it 'should create maximum number of cmrs for a single page' do
    25.times { create_and_route_cmr }
  end

  it 'should change view to special queue' do
    @browser.click "link=EVENTS"
    wait_for_element_present(:text, "Events")
    @browser.click "link=Change View"
    @browser.add_selection "//div[@id='change_view']//select[@id='queues_selector']", "label=#{@queue_name}-UtahCounty"
    @browser.click "change_view_btn"
    sleep(1)
  end

  it 'should not display pagination' do
    @browser.is_element_present("//a[@class='next_page']").should be_false
  end

  it 'should add one more cmr to the queue' do
    create_and_route_cmr
  end

  it 'should display pagination' do
    @browser.click "link=EVENTS"
    wait_for_element_present(:text, "Events")
    @browser.click "link=Change View"
    @browser.add_selection "//div[@id='change_view']//select[@id='queues_selector']", "label=#{@queue_name}-UtahCounty"
    @browser.click "change_view_btn"
    sleep(1)
    @browser.is_element_present("//a[@class='next_page']").should be_true
  end

  it 'should re-paginate to 50 per page' do
    @browser.click "link=EVENTS"
    wait_for_element_present(:text, "Events")
    @browser.click "link=Change View"
    @browser.add_selection "//div[@id='change_view']//select[@id='queues_selector']", "label=#{@queue_name}-UtahCounty"
    @browser.select "//select[@id='per_page']", "label=50"
    @browser.click "change_view_btn"
    sleep(1)
    @browser.is_element_present("//a[@class='next_page']").should be_false
  end
end
    
