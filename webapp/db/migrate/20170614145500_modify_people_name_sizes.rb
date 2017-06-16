# remove limitation on name size
#

class ModifyPeopleNameSizes < ActiveRecord::Migration
  def self.up
    execute "DROP VIEW clinician"
    execute "DROP VIEW hepatitis"
    execute "DROP VIEW table_link"
    execute "ALTER TABLE people ALTER COLUMN first_name TYPE varchar"
    execute "ALTER TABLE people ALTER COLUMN middle_name TYPE varchar"
    execute "ALTER TABLE people ALTER COLUMN last_name TYPE varchar"
    execute %{
      CREATE OR REPLACE VIEW clinician AS 
       SELECT people.first_name, people.middle_name, people.last_name, people.person_type
         FROM people
        WHERE people.person_type IS NOT NULL;  
    }
    execute %{
      CREATE OR REPLACE VIEW hepatitis AS 
       SELECT event2.disease_event_id, event2.disease_onset_date, event2.disease_id, event2.disease_name, event2.event_id, event2.record_number, event2.event_type, event2.event_onset_date, event2.workflow_state, event2.participation_id, event2.primary_entity_id, event2.people_id, event2.first_name, event2.last_name, event2.middle_name, event2.birth_date, event2.ext_code_id, event2.sex, lab2.lab_result_id, lab2.collection_date, lab2.lab_test_date, event2.case_classification
         FROM ( SELECT DISTINCT ON (devent.id) devent.id AS disease_event_id, devent.disease_onset_date, diseases.id AS disease_id, diseases.disease_name, events.id AS event_id, events.record_number, events.type AS event_type, events.event_onset_date, events.workflow_state, events.lhd_case_status_id, ext2.code_description AS case_classification, part.id AS participation_id, part.primary_entity_id, people.id AS people_id, people.first_name, people.last_name, people.middle_name, people.birth_date, ext.id AS ext_code_id, ext.the_code AS sex
                 FROM disease_events devent
            JOIN diseases ON devent.disease_id = diseases.id AND diseases.disease_name::text ~~ 'Hepatitis%'::text
         JOIN events ON devent.event_id = events.id AND events.type::text = 'MorbidityEvent'::text
         LEFT JOIN external_codes ext2 ON events.lhd_case_status_id = ext2.id
         LEFT JOIN participations part ON events.id = part.event_id
         LEFT JOIN people ON part.primary_entity_id = people.entity_id
         LEFT JOIN external_codes ext ON people.birth_gender_id = ext.id
        ORDER BY devent.id, people.first_name, people.last_name, people.birth_date, ext.the_code) event2
         LEFT JOIN ( SELECT DISTINCT ON (events.id) events.id AS event_id, events.event_onset_date, lab.id AS lab_result_id, lab.collection_date, lab.lab_test_date
                 FROM events
            LEFT JOIN participations part ON events.id = part.event_id
         LEFT JOIN lab_results lab ON part.id = lab.participation_id
        ORDER BY events.id, lab.collection_date, lab.lab_test_date) lab2 ON event2.event_id = lab2.event_id;
    }
    execute %{
      CREATE OR REPLACE VIEW "table_link" AS 
       SELECT msg.id AS msg_id, msg.hl7_message, msg.patient_first_name, msg.patient_last_name, msg.created_at AS msg_created_at, msg.state AS msg_state, msg.laboratory_name, lab.id AS lab_result_id, lab.created_at AS lab_result_created_at, lab.loinc_code, part.id AS participation_id, part.created_at AS participation_created_at, part.primary_entity_id, part.event_id, events.record_number, events.created_at AS event_created_at, events.type AS event_type, events.event_onset_date, events.workflow_state, people.id AS people_id, people.created_at AS people_created_at, people.first_name, people.last_name, people.middle_name, people.birth_date, people.date_of_death, devent.id AS disease_event_id, devent.created_at AS disease_event_created_at, devent.hospitalized_id, devent.died_id, devent.disease_onset_date, diseases.id AS disease_id, diseases.disease_name
         FROM staged_messages msg
         LEFT JOIN lab_results lab ON msg.id = lab.staged_message_id
         LEFT JOIN participations part ON lab.participation_id = part.id
         LEFT JOIN events ON part.event_id = events.id
         LEFT JOIN people ON part.primary_entity_id = people.entity_id
         LEFT JOIN disease_events devent ON part.event_id = devent.event_id
         LEFT JOIN diseases ON devent.disease_id = diseases.id
        ORDER BY msg.id;
    }
  end
  def self.down
  end
end
