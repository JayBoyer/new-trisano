INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'worker', 'STD_field_record', 'ooj_worker', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'worker', 'STD_contact_field_record', 'ooj_worker', NULL, NULL, 'replace_if_dst_blank', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'record_number', '', '', NULL, NULL, 'record_number', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'ooj_state', 'core', 'address|state_id', 'state', NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'ooj_county', 'core', 'address|county_id', 'county', NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'last_name', 'core', 'interested_party|person_entity|person|last_name', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'first_name', 'core', 'interested_party|person_entity|person|first_name', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'middle_initial', 'core', 'interested_party|person_entity|person|middle_name', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'aka', 'STD_core_elements', 'aka', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'date_of_birth', 'core', 'interested_party|person_entity|person|birth_date', NULL, '-', 'date_m_d_y', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'age', '', '', NULL, NULL, 'age', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'birth_gender', 'core', 'interested_party|person_entity|person|birth_gender_id', 'gender', NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'current_gender', 'STD_core_elements', 'current_gender', NULL, NULL, 'answer_code', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'marital_status', 'STD_core_elements', 'marital_status', NULL, NULL, 'answer_code', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'ethnicity', 'core', 'interested_party|person_entity|person|ethnicity_id', 'ethnicity', NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'race', 'core', 'interested_party|person_entity|race_ids', 'race', NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'height', 'std_physical_desc', 'height', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'size', 'std_physical_desc', 'size', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'complexion', 'std_physical_desc', 'complexion', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'hair', 'std_physical_desc', 'hair', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'other_physical_desc', 'std_physical_desc', 'other_physical_desc', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value)
  VALUES ('ooj', 'address', 'core', 'address|street_number', NULL, ' ', NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'address', 'core', 'address|street_name', NULL, ' ', 'concat', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'unit_number', 'core', 'address|unit_number', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'city', 'core', 'address|city', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'state', 'core', 'address|state_id', 'state', NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'zip', 'core', 'address|postal_code', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'county', 'core', 'address|county_id', 'county', NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'phone_number', 'core', 'interested_party|person_entity|telephones|area_code', NULL, ' ', NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'phone_number', 'core', 'interested_party|person_entity|telephones|phone_number', NULL, '-', 'concat', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'phone_number', 'core', 'interested_party|person_entity|telephones|extension', NULL, ' x', 'concat', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'other_location', 'core', 'address|county_id', 'county', NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'first_exposure', 'STD_field_record', 'first_exp', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'exposure_frequency', 'STD_field_record', 'freq_exp', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'last_exposure', 'STD_field_record', 'last_exp', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'first_exposure', 'STD_contact_field_record', 'first_exp', NULL, NULL, 'replace_if_dst_blank', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'exposure_frequency', 'STD_contact_field_record', 'freq_exp', NULL, NULL, 'replace_if_dst_blank', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'last_exposure', 'STD_contact_field_record', 'last_exp', NULL, NULL, 'replace_if_dst_blank', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'letter_date', '', '', NULL, NULL, 'date_now', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'full_name', 'core', 'interested_party|person_entity|person|first_name', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'full_name', 'core', 'interested_party|person_entity|person|last_name', NULL, ' ', 'concat', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'lab_results', '', '', NULL, NULL, 'lab_results', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'treatments', '', '', NULL, NULL, 'treatments', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('ooj', 'investigator_name', 'core', 'investigator|best_name', NULL, NULL, NULL, NULL);

  
