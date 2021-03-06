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
module EventSearch
  def self.included(base)
    base.class_eval do
      extend(ClassMethods)
      extend(FulltextSearch::ClassMethods)
    end
  end

  module ClassMethods
    def find_by_criteria(*args)
      options = args.extract_options!
      options[:fulltext_terms] = options[:fulltext_terms].strip if options[:fulltext_terms]
      return unless issue_query?(options)
      Event.find_by_sql(construct_criteria_sql(options))
    end

    def issue_query?(options)
      [:event_type,
       :diseases,
       :gender,
       :workflow_state,
       :street_number,
       :street_name,
       :city,
       :area_code,
       :phone_number,
       :starts_with_aka_name,
       :accession_no,
       :county,
       :jurisdiction_ids,
       :birth_date,
       :entered_on_start,             :entered_on_end,
       :first_reported_PH_date_start, :first_reported_PH_date_end,
       :record_number,
       :pregnant_id,
       :state_case_status_ids,
       :lhd_case_status_ids,
       :investigator_ids,
       :other_data_1,                 :other_data_2,
       :sent_to_cdc,
       :sw_last_name,                 :sw_first_name,
       :fulltext_terms
      ].any? {|key| !options[key].blank?} && searchable_event_type?(options)
    end

    def searchable_event_type?(options)
      ['MorbidityEvent', 'ContactEvent', 'AssessmentEvent', '', nil].include?(options[:event_type])
    end

    def construct_criteria_sql(options)
      returning [] do |sql|
        sql << "SELECT * FROM ("
        sql << "SELECT"
        sql << event_search_select(options)
        sql << "FROM events"
        sql << event_search_joins(options).join("\n")
        sql << "WHERE"
        sql << event_search_conditions(options).join("\nAND\n")
        sql << ") as results"
        sql << "ORDER BY"
        sql << event_search_order(options)
        sql << event_search_limit(options)
      end.compact.join("\n")
    end

    def event_search_select(options)
      returning "" do |result|
        result << "DISTINCT\n"
        result << event_search_select_fields(options).join(",\n")
      end
    end

    def event_search_select_fields(options)
      returning [] do |fields|
        fields << "events.id AS id"
        fields << "events.type AS type"
        fields << "events.deleted_at AS deleted_at"
        fields << "events.record_number AS record_number"
        fields << "events.workflow_state AS workflow_state"
        fields << "entities.id AS patient_entity_id"
        fields << "people.last_name AS last_name"
        fields << "people.first_name AS first_name"
        fields << "people.middle_name AS middle_name"
        fields << "people.approximate_age_no_birthday AS approximate_age_no_birthday"
        fields << "people.birth_date AS birth_date"
        fields << "people_gender.code_description AS birth_gender"
        fields << "diseases.disease_name AS disease_name"
        fields << "addresses.city AS city"
        fields << "counties_addresses.code_description AS county"
        fields << "places.short_name AS jurisdiction"
        fields << "disease_events.disease_onset_date AS onset_date"
        fields << "lab_results.accession_no AS accession_no"
        fields << "lab_results.collection_date AS collection_date"
        fields << "#{search_rank(options)} AS rank" unless name_and_date_blank?(options)
      end.flatten.compact
    end

    def event_search_joins(options)
      fulltext_options = fulltext(options)

      returning [] do |joins|
        joins << "INNER JOIN participations interested_party ON interested_party.event_id = events.id AND (interested_party.type = 'InterestedParty' )"
        joins << "INNER JOIN entities ON entities.id = interested_party.primary_entity_id AND (entities.entity_type = 'PersonEntity' )"
        joins << "INNER JOIN people ON people.entity_id = entities.id" + (fulltext_options.blank? ? "" : " AND " + fulltext_options)
        joins << "LEFT OUTER JOIN external_codes people_gender ON people_gender.id = people.birth_gender_id"
        if(!pregnancy_conditions(options).blank?)
          joins << "LEFT OUTER JOIN participations_risk_factors ON participations_risk_factors.participation_id = interested_party.id"
        end
        joins << "LEFT OUTER JOIN telephones ON telephones.entity_id = entities.id"
        joins << "LEFT OUTER JOIN addresses ON addresses.event_id = events.id"
        joins << "LEFT OUTER JOIN external_codes counties_addresses ON counties_addresses.id = addresses.county_id"
        joins << "LEFT OUTER JOIN disease_events ON disease_events.event_id = events.id"
        joins << "LEFT OUTER JOIN diseases ON diseases.id = disease_events.disease_id"
        joins << "INNER JOIN participations jurisdictions_events ON jurisdictions_events.event_id = events.id AND (jurisdictions_events.type = 'Jurisdiction' )"
        joins << <<-JOIN
          INNER JOIN entities place_entities_participations ON place_entities_participations.id = jurisdictions_events.secondary_entity_id
            AND (place_entities_participations.entity_type = 'PlaceEntity' )
        JOIN
        joins << "INNER JOIN places ON places.entity_id = place_entities_participations.id"
        joins << <<-JOIN
          LEFT OUTER JOIN participations associated_jurisdictions_events ON associated_jurisdictions_events.event_id = events.id
            AND (associated_jurisdictions_events.type = 'AssociatedJurisdiction' )
        JOIN
        if options[:accession_no].blank?
          joins << <<-JOIN
            LEFT OUTER JOIN lab_results on lab_results.id = (SELECT lab_results.id FROM lab_results 
              INNER JOIN participations ON participations.event_id = events.id AND participations.type = 'Lab' AND 
                lab_results.participation_id = participations.id AND
                lab_results.collection_date IS NOT NULL
              ORDER BY lab_results.collection_date DESC LIMIT 1)
          JOIN
        else
          joins << <<-JOIN
            INNER JOIN participations lab ON lab.event_id = events.id AND (lab.type = 'Lab')
            INNER JOIN lab_results ON lab_results.participation_id = lab.id            
          JOIN
        end
        if(!aka_conditions(options).blank?)
          joins << <<-JOIN
            LEFT OUTER JOIN answers ON events.id = (SELECT answers.event_id FROM answers
              INNER JOIN questions ON questions.id = answers.question_id AND questions.short_name = 'AKA' LIMIT 1)
          JOIN
        end
      end.flatten.compact
    end

    def event_search_order(options)
      if name_and_date_blank?(options)
        "type DESC, last_name, first_name ASC"
      else
        fulltext_order(options)
      end
    end

    def event_search_limit(options)
      limit = options[:limit].to_i
      "LIMIT #{limit}" if limit > 0
    end

    def event_search_conditions(options)
      returning [] do |where|
        where << event_type_conditions(options)
        where << disease_conditions(options)
        where << gender_conditions(options)
        where << workflow_conditions(options)
        where << street_name_conditions(options)
        where << street_number_conditions(options)
        where << city_conditions(options)
        where << area_code_conditions(options)
        where << phone_number_conditions(options)
        where << aka_conditions(options)
        where << accession_conditions(options)
        where << county_conditions(options)
        where << jurisdiction_conditions(options)
        where << sensitive_disease_conditions(options)
        where << entered_on_conditions(options)
        where << first_reported_conditions(options)
        where << pregnancy_conditions(options)
        where << record_number_conditions(options)
        where << state_status_conditions(options)
        where << lhd_status_conditions(options)
        where << investigator_conditions(options)
        where << other_data_conditions(options)
        where << cdc_conditions(options)
        where << name_conditions(options)
      end.flatten.compact
    end

    def event_type_conditions(options)
      if options[:event_type].blank?
        "(events.type = 'MorbidityEvent' OR events.type = 'ContactEvent' OR events.type = 'AssessmentEvent')"
      else
        sanitize_sql_for_conditions(['events.type = ?', options[:event_type]])
      end
    end

    def disease_conditions(options)
      unless options[:diseases].blank?
        sanitize_sql_for_conditions(['disease_id IN (?)', options[:diseases]])
      end
    end

    def gender_conditions(options)
      unless options[:gender].blank?
        if options[:gender] == "Unspecified"
          "birth_gender_id IS NULL"
        else
          sanitize_sql_for_conditions(["birth_gender_id = ?", options[:gender]])
        end
      end
    end

    def workflow_conditions(options)
      unless options[:workflow_state].blank?
        sanitize_sql_for_conditions(["workflow_state = ?", options[:workflow_state]])
      end
    end

    def street_number_conditions(options)
      starts_with_conditions(:addresses, :street_number, options)
    end
    
    def street_name_conditions(options)
      starts_with_conditions(:addresses, :street_name, options)
    end
    
    def city_conditions(options)
      starts_with_conditions(:addresses, :city, options)
    end
    
    def area_code_conditions(options)
      in_condition(:telephones, :area_code, options)
    end

    def phone_number_conditions(options)
      unless options[:phone_number].blank?
        phone_number_no_dash = options[:phone_number].strip.gsub(/\-/, "")
        unless phone_number_no_dash.blank?
          sanitize_sql_for_conditions(["telephones.phone_number IN (?)", phone_number_no_dash])
        end
      end
    end

    def county_conditions(options)
      unless options[:county].blank?
        sanitize_sql_for_conditions(['county_id = ?', options[:county]])
      end
    end

    def jurisdiction_conditions(options)
      unless options[:jurisdiction_ids].blank?
        conditions = ["jurisdictions_events.secondary_entity_id IN (?)", options[:jurisdiction_ids]]
      else
        allowed_jurisdiction_ids =  User.current_user.jurisdictions_for_privilege(:view_event).map(&:entity_id)
        allowed_jurisdiction_ids += User.current_user.jurisdictions_for_privilege(:update_event).map(&:entity_id)
        allowed_ids = allowed_jurisdiction_ids.uniq

        unless allowed_ids.blank?
          conditions = [<<-SQL, allowed_ids, allowed_ids]
           (jurisdictions_events.secondary_entity_id IN (?)
              OR associated_jurisdictions_events.secondary_entity_id IN (?) )
          SQL
        end
      end
      sanitize_sql_for_conditions(conditions)
    end

    def sensitive_disease_conditions(options)
      allowed_ids = options[:access_sensitive_jurisdiction_ids]
      allowed_ids ||= User.current_user.jurisdiction_ids_for_privilege(:access_sensitive_diseases) if User.current_user
      conditions = [ <<-SQL, allowed_ids, allowed_ids ]
        (diseases.sensitive IS NULL OR NOT diseases.sensitive OR
         jurisdictions_events.secondary_entity_id IN (?)
         OR associated_jurisdictions_events.secondary_entity_id IN (?))
      SQL
      sanitize_sql_for_conditions(conditions)
    end

    def entered_on_conditions(options)
      date_range_conditions(:events, :created_at, :entered_on_start, :entered_on_end, options)
    end

    def first_reported_conditions(options)
      date_range_conditions(:events, :first_reported_PH_date, options)
    end

    def record_number_conditions(options)
      unless options[:record_number].blank?
        sanitize_sql_for_conditions(['events.record_number = ?', options[:record_number].strip()])
      end
    end

    def pregnancy_conditions(options)
      unless options[:pregnant_id].blank?
        sanitize_sql_for_conditions(['participations_risk_factors.pregnant_id = ?', options[:pregnant_id]])
      end
    end

    def state_status_conditions(options)
      in_conditions(:events, :state_case_status_ids, options)
    end

    def lhd_status_conditions(options)
      in_conditions(:events, :lhd_case_status_ids, options)
    end

    def investigator_conditions(options)
      in_conditions(:events, :investigator_ids, options)
    end

    def other_data_conditions(options)
      returning [] do |c|
        c << starts_with_conditions(:events, :other_data_1, options)
        c << starts_with_conditions(:events, :other_data_2, options)
      end
    end

    def cdc_conditions(options)
      unless options[:sent_to_cdc].blank?
        if true.to_s == options[:sent_to_cdc]
          "events.sent_to_cdc = true"
        else
          "(events.sent_to_cdc = false OR events.sent_to_cdc is NULL)"
        end
      end
    end

    # DEBT: sometimes starts w/ is check box triggered and sometimes not.
    def name_conditions(options, *keys)
      identifier = keys.slice!(-1)
      return if identifier && options[identifier].nil?
      last_name = keys.slice!(0)  || :sw_last_name
      first_name = keys.slice!(0) || :sw_first_name

      if options[last_name].blank?
        unless options[first_name].blank?
          result = ["first_name ILIKE ?", options[first_name] + '%']
        end
      else
        if options[first_name].blank?
          result = ["last_name ILIKE ?", options[last_name] + '%']
        else
          result = ["(last_name ILIKE ? AND first_name ILIKE ?)",
                    options[last_name] + '%',
                    options[first_name] + '%']
        end
      end
      sanitize_sql_for_conditions(result) if defined? result
    end
    
    def aka_conditions(options)
      unless options[:starts_with_aka_name].blank?
        sanitize_sql_for_conditions(["answers.text_answer ILIKE ?", options[:starts_with_aka_name] + "%"])
      end
    end

    def accession_conditions(options)
      unless options[:accession_no].blank?
        sanitize_sql_for_conditions(["lab_results.accession_no ILIKE ?", "%" + options[:accession_no] + "%"])
      end
    end

    def in_condition(table, field, options)
      unless options[field].blank?
        sanitize_sql_for_conditions(["#{table.to_s}.#{field.to_s} IN (?)", options[field]])
      end
    end

    def in_conditions(table, field, options)
      unless options[field].blank?
        sanitize_sql_for_conditions(["#{table.to_s}.#{field.to_s.chop} IN (?)", options[field]])
      end
    end

    def starts_with_conditions(table, field, options)
      unless options[field].blank?
        sanitize_sql_for_conditions(["#{table.to_s}.#{field.to_s} ILIKE ?", options[field] + "%"])
      end
    end

    def date_range_conditions(table, field, *keys_and_options)
      options = keys_and_options.extract_options!
      start_k = keys_and_options[0] || "#{field.to_s}_start".to_sym
      end_k   = keys_and_options[1] || "#{field.to_s}_end".to_sym
      if options[start_k].blank?
        unless options[end_k].blank?
          conditions = ["#{table.to_s}.\"#{field.to_s}\" <= ?", options[end_k]]
        end
      else
        if options[end_k].blank?
          conditions = ["#{table.to_s}.\"#{field.to_s}\" >= ?", options[start_k]]
        else
          conditions = ["#{table.to_s}.\"#{field.to_s}\" BETWEEN ? AND ?", options[start_k], options[end_k]]
        end
      end
      sanitize_sql_for_conditions(conditions) if defined? conditions
    end

  end
end

