class CreateOoeViews < ActiveRecord::Migration
  def self.up
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
    execute %{
      CREATE OR REPLACE VIEW interested_parties AS 
       SELECT DISTINCT ON (participations.id) participations.id, participations.primary_entity_id, participations.event_id
         FROM participations
         JOIN events ON events.id = participations.event_id
         JOIN participations jurispart ON jurispart.type::text = 'Jurisdiction'::text AND jurispart.event_id = events.id
         JOIN places jurisplace ON jurisplace.entity_id = jurispart.secondary_entity_id
         LEFT JOIN ( SELECT sec_juris_inner.event_id, 
              CASE
                  WHEN sec_juris_inner.secondary_jurisdiction_inner IS DISTINCT FROM ARRAY[NULL::integer] THEN sec_juris_inner.secondary_jurisdiction_inner
                  ELSE ARRAY[]::integer[]
              END AS secondary_jurisdiction_entity_ids
         FROM ( SELECT events.id AS event_id, array_accum(p.secondary_entity_id) AS secondary_jurisdiction_inner
                 FROM events
            LEFT JOIN participations p ON p.event_id = events.id AND p.type::text = 'AssociatedJurisdiction'::text
           GROUP BY events.id) sec_juris_inner) sec_juris ON sec_juris.event_id = events.id
         LEFT JOIN disease_events ON disease_events.event_id = events.id
         LEFT JOIN diseases ON disease_events.disease_id = diseases.id
        WHERE participations.type::text = 'InterestedParty'::text AND (events.type::text = ANY (ARRAY['MorbidityEvent'::character varying, 'ContactEvent'::character varying, 'AssessmentEvent'::character varying]::text[])) AND (diseases.sensitive IS NULL OR NOT diseases.sensitive OR (sec_juris.secondary_jurisdiction_entity_ids || jurispart.secondary_entity_id) && (ARRAY( SELECT DISTINCT rm.jurisdiction_id
         FROM privileges p
         JOIN privileges_roles pr ON pr.privilege_id = p.id
         JOIN role_memberships rm USING (role_id)
         JOIN users u ON u.id = rm.user_id
        WHERE p.priv_name::text = 'access_sensitive_diseases'::text AND u.id = 9)));
    }
    execute %{
      CREATE OR REPLACE VIEW vw_recent_flu AS 
       WITH query AS (
         SELECT d.report_date, count(d.id) AS reports, sum(d.cases_approved) AS cases_approved, sum(d.cases_under_investigation) AS cases_under_investigation, sum(d.cases_in_process) AS cases_in_process, sum(d.flu) AS flu, sum(d.flu_novel) AS flu_novel, sum(d.age_group_0_to_4) AS age_group_0_to_4, sum(d.age_group_5_to_17) AS age_group_5_to_17, sum(d.age_group_18_to_49) AS age_group_18_to_49, sum(d.age_group_50_to_64) AS age_group_50_to_64, sum(d.age_group_65_and_over) AS age_group_65_and_over, sum(d.age_group_unknown) AS age_group_unknown, sum(d.hospitalized) AS hospitalizations, sum(d.died) AS deaths
           FROM ( SELECT e.id, e.created_at::date AS report_date, 
                CASE
                  WHEN e.workflow_state::text = 'approved_by_lhd'::text THEN 1
                    ELSE 0
                  END AS cases_approved, 
                CASE
                  WHEN e.workflow_state::text = 'under_investigation'::text THEN 1
                    ELSE 0
                  END AS cases_under_investigation, 
                CASE
                  WHEN e.workflow_state::text <> 'approved_by_lhd'::text AND e.workflow_state::text <> 'under_investigation'::text THEN 1
                    ELSE 0
                  END AS cases_in_process, 
                CASE
                  WHEN d.disease_id = 144 THEN 1
                    ELSE 0
                  END AS flu, 
                CASE
                  WHEN d.disease_id = 89 THEN 1
                    ELSE 0
                  END AS flu_novel, 
                CASE
                  WHEN e.age_type_id = 161 OR e.age_type_id = 162 OR e.age_type_id = 163 OR e.age_type_id = 160 AND e.age_at_onset < 5 AND e.age_at_onset IS NOT NULL THEN 1
                    ELSE 0
                  END AS age_group_0_to_4, 
                CASE
                  WHEN e.age_type_id = 160 AND e.age_at_onset >= 5 AND e.age_at_onset <= 17 THEN 1
                    ELSE 0
                  END AS age_group_5_to_17, 
                CASE
                  WHEN e.age_type_id = 160 AND e.age_at_onset >= 18 AND e.age_at_onset <= 49 THEN 1
                    ELSE 0
                  END AS age_group_18_to_49, 
                CASE
                  WHEN e.age_type_id = 160 AND e.age_at_onset >= 50 AND e.age_at_onset <= 64 THEN 1
                    ELSE 0
                  END AS age_group_50_to_64, 
                CASE
                  WHEN e.age_type_id = 160 AND e.age_at_onset >= 65 THEN 1
                    ELSE 0
                  END AS age_group_65_and_over, 
                CASE
                  WHEN e.age_type_id = 164 OR e.age_type_id = 165 OR e.age_type_id IS NULL THEN 1
                    ELSE 0
                  END AS age_group_unknown, 
                CASE
                  WHEN d.hospitalized_id = 106 THEN 1
                    ELSE 0
                  END AS hospitalized, 
                CASE
                  WHEN d.died_id = 106 THEN 1
                    ELSE 0
                  END AS died
                FROM events e
                  LEFT JOIN disease_events d ON e.id = d.event_id
                  WHERE e.created_at::date <= 'now'::text::date AND e.created_at::date >= ('now'::text::date - 14) AND (d.disease_id = 144 OR d.disease_id = 89) AND e.type::text = 'MorbidityEvent'::text) d
                GROUP BY d.report_date
              )
       SELECT d.report_date, COALESCE(q.reports, 0::bigint) AS reports, COALESCE(q.cases_approved, 0::bigint) AS cases_approved, COALESCE(q.cases_under_investigation, 0::bigint) AS cases_under_investigation, COALESCE(q.cases_in_process, 0::bigint) AS cases_in_process, COALESCE(q.flu, 0::bigint) AS flu, COALESCE(q.flu_novel, 0::bigint) AS flu_novel, COALESCE(q.age_group_0_to_4, 0::bigint) AS age_group_0_to_4, COALESCE(q.age_group_5_to_17, 0::bigint) AS age_group_5_to_17, COALESCE(q.age_group_18_to_49, 0::bigint) AS age_group_18_to_49, COALESCE(q.age_group_50_to_64, 0::bigint) AS age_group_50_to_64, COALESCE(q.age_group_65_and_over, 0::bigint) AS age_group_65_and_over, COALESCE(q.age_group_unknown, 0::bigint) AS age_group_unknown, COALESCE(q.hospitalizations, 0::bigint) AS hospitalizations, COALESCE(q.deaths, 0::bigint) AS deaths
         FROM ( SELECT 'now'::text::date - rd.a AS report_date
                 FROM generate_series(0, 14) rd(a)) d
         LEFT JOIN query q ON q.report_date = d.report_date;
    }
  end
    
  def self.down
    execute "DROP VIEW clinician"
    execute "DROP VIEW hepatitis"
    execute "DROP VIEW interested_parties"
    execute "DROP VIEW table_link"
    execute "DROP VIEW vw_recent_flu"
  end
end