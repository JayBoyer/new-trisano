require File.dirname(__FILE__) + '/../../spec_helper'

describe "/cmrs/new.html.erb" do

  before(:each) do
    
    @event = mock_event
    
    @participation = mock_model(Participation)
    @primary_entity =  mock_person_entity
    @active_jurisdiction = mock_model(Participation)
    @active_hospital = mock_model(Participation)
    @hospitals_participation = mock_model(HospitalsParticipation)
    
    @event.stub!(:active_patient).and_return(@participation)
    @event.stub!(:active_jurisdiction).and_return(@active_jurisdiction)
    @event.stub!(:active_hospital).and_return(@active_hospital)
    @participation.stub!(:active_primary_entity).and_return(@primary_entity)
    @active_jurisdiction.stub!(:secondary_entity_id).and_return(1)
    @active_hospital.stub!(:secondary_entity_id).and_return(13)
    @active_hospital.stub!(:hospitals_participation).and_return(@hospitals_participation)
    @hospitals_participation.stub!(:admission_date).and_return("2008-02-15")
    @hospitals_participation.stub!(:discharge_date).and_return("2009-02-15")
    
    assigns[:event] = @event
    
  end
  
  def do_render
    render "/events/new.html.erb"
  end

  it "should render new event form" do
    do_render
    response.should have_tag("form[action=?][method=post]", cmrs_path) do
    end
  end

  it "should have more tests" do
    #...
  end

end