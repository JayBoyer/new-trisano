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

class LabResult < ActiveRecord::Base
  include Trisano::Repeater
  belongs_to :specimen_source, :class_name => 'ExternalCode'
  belongs_to :specimen_sent_to_state, :class_name => 'ExternalCode'
  belongs_to :test_result, :class_name => 'ExternalCode'
  belongs_to :participation
  belongs_to :staged_message
  belongs_to :organism
  belongs_to :test_type, :class_name => 'CommonTestType'
  belongs_to :test_status, :class_name => 'ExternalCode'

  delegate :event, :to => :participation, :prefix => true, :allow_nil => true

  after_create :generate_task
  
  after_create do |lab_result|
    if event=lab_result.participation_event
      event.add_note(I18n.translate("system_notes.lab_result_created", :locale => I18n.default_locale, :accession_no => lab_result.accession_no, :lab_name => lab_result.lab_name))
    end
  end

  before_destroy do |lab_result|
    if event = lab_result.participation_event
      event.add_note(I18n.translate("system_notes.lab_result_deleted", :locale => I18n.default_locale, :accession_no => lab_result.accession_no, :lab_name => lab_result.lab_name))
    end
  end

  validates_presence_of :test_type_id
  validates_length_of :result_value, :maximum => 10485760, :allow_blank => true
  validates_length_of :units, :maximum => 50, :allow_blank => true
  validates_length_of :reference_range, :maximum => 255, :allow_blank => true

  validates_date :collection_date,  :allow_blank => true,
                                    :on_or_before => lambda { Date.today }

  validates_date :lab_test_date, :allow_blank => true,
                                 :on_or_before => lambda { Date.today } , #Lab test date cannot be in the future
                                 :on_or_after => :collection_date # Lab test must come after collection date

  def xml_fields
    [[:specimen_sent_to_state_id, {:rel => :yesno}],
     [:specimen_source_id, {:rel => :specimen_source}],
     :reference_range,
     :collection_date,
     [:test_status_id, {:rel => :test_status}],
     [:test_result_id, {:rel => :test_result}],
     :lab_test_date,
     [:test_type_id, {:rel => :test_type}],
     :units,
     :result_value,
     [:organism_id, {:rel => :organism}],
     :comment
    ]
  end

  def lab_name
    participation.secondary_entity.place.name unless participation.nil?
  end

  def generate_task
    event = participation.try :event
    investigator = event.try  :investigator
    if investigator && investigator != User.current_user
      Task.create!(:name     => "New lab result added: #{test_type.common_name}",
                   :due_date => Date.today,
                   :user     => investigator,
                   :event    => event,
                   :system_generated => true)
    end
  end
  
  def assigned_event
    self.try(:participation).try(:event)
  end
  
  # move a lab result assigned to an event to a new event
  def move_to_event(record_number)
    if(record_number.length == 0)
      return "invalid_event"
    else
      event = Event.find(:first, :conditions => ["record_number = ?", record_number])
      if(event.nil?)
        return "invalid_event"
      end
      if(event.type != 'MorbidityEvent' && event.type != 'AssessmentEvent' && event.type != 'ContactEvent')
        return "ae_cmr_contact_event"
      end
      event_id = event.id
      if(self.staged_message_id.blank?)
        lab_results = [self]
      else
        lab_results = LabResult.find(:all, :conditions => ["staged_message_id =?", self.staged_message_id])
      end
      event_ids = Set.new([event_id])
      lab_results.each do |lab_result|
        participation = Participation.find(:first, :conditions => ["id = ?", lab_result.participation_id])
        if(participation.event_id != event_id)
          event_ids.add(participation.event_id)
          participation.event_id = event_id
          participation.send(:update_without_callbacks)
        end
      end
      event_ids.each do |id|
        redis.delete_matched("views/events/#{id}/*")  
      end
    end
    return "success_reassign"
  end

  def un_assign
    if(!self.staged_message_id.blank?)
      staged_message = StagedMessage.find(self.staged_message_id)
      staged_message.un_assign
    end
  end
  
end
