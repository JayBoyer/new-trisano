INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'patient_name', 'core', 'interested_party|person_entity|person|last_name', NULL, ', ', NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'patient_name', 'core', 'interested_party|person_entity|person|first_name', NULL, ' ', 'concat', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'patient_name', 'core', 'interested_party|person_entity|person|middle_name', NULL, ' ', 'concat', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'date_of_birth', 'core', 'interested_party|person_entity|person|birth_date', NULL, '  -  ', 'date_m_d_y', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'alias', 'STD_core_elements', 'aka', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'phone_number', 'core', 'interested_party|person_entity|telephones|area_code', NULL, ' ', NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'phone_number', 'core', 'interested_party|person_entity|telephones|phone_number', NULL, '-', 'concat', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'phone_number', 'core', 'interested_party|person_entity|telephones|extension', NULL, ' x', 'concat', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value)
  VALUES ('hars', 'address', 'core', 'address|street_number', NULL, ' ', NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'address', 'core', 'address|street_name', NULL, ' ', 'concat', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'address', 'core', 'address|unit_number', NULL, ' #', 'concat', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'city', 'core', 'address|city', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'zip_code', 'core', 'address|postal_code', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'county', 'core', 'address|county_id', 'county', NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'state', 'core', 'address|state_id', 'state', NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'date_form_completed', 'core', '', NULL, NULL, 'date_today', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'disease_aids_infection', 'core', 'disease_event|disease_id', NULL, NULL, 'check_box', '49');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'disease_aids_infection', 'core', 'disease_event|disease_id', NULL, NULL, 'check_box', '164');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'disease_hiv_infection', 'core', 'disease_event|disease_id', NULL, NULL, 'check_box', '53');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'disease_hiv_infection', 'core', 'disease_event|disease_id', NULL, NULL, 'check_box', '54');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'disease_hiv_infection', 'core', 'disease_event|disease_id', NULL, NULL, 'check_box', '165');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'disease_hiv_infection', 'core', 'disease_event|disease_id', NULL, NULL, 'check_box', '166');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'disease_hiv_infection', 'core', 'disease_event|disease_id', NULL, NULL, 'check_box', '169');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'disease_hiv_infection', 'core', 'disease_event|disease_id', NULL, NULL, 'check_box', '184');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'birth_sex_male', 'core', 'interested_party|person_entity|person|birth_gender_id', 'gender', NULL, 'check_box', 'M');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'birth_sex_female', 'core', 'interested_party|person_entity|person|birth_gender_id', 'gender', NULL, 'check_box', 'F');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'birth_sex_unknown', 'core', 'interested_party|person_entity|person|birth_gender_id', 'gender', NULL, 'check_box', 'U');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'state_patient_number', 'std_ehars_ID', 'hars_stateno', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', NULL, 'core', 'interested_party|person_entity|person|birth_date', NULL, NULL, 'push', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'hiv_age_diagnosis', 'std_ehars_ID', 'hiv_dx_dt', NULL, NULL, 'age_subtract', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', NULL, 'core', 'interested_party|person_entity|person|birth_date', NULL, NULL, 'push', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'aids_age_diagnosis', 'std_ehars_ID', 'aids_dx_dt', NULL, NULL, 'age_subtract', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'birth_us', 'STD_core_elements', 'country_birth', NULL, NULL, 'check_box', '');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'birth_other', 'STD_core_elements', 'country_birth', NULL, NULL, 'check_box_invert', '');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'social_security_number', 'STD_core_elements', 'ssn', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'social_security_number', 'STD_contact_field_record', 'ssn', NULL, NULL, 'replace_if_dst_blank', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'birth_country', 'STD_core_elements', 'country_birth', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'seperated', 'STD_core_elements', 'marital_status', NULL, NULL, 'check_box', 'SEP - Separated');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'divorced', 'STD_core_elements', 'marital_status', NULL, NULL, 'check_box', 'D - Divorced');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'married', 'STD_core_elements', 'marital_status', NULL, NULL, 'check_box', 'M - Married');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'single', 'STD_core_elements', 'marital_status', NULL, NULL, 'check_box', 'S - Single, Never Married');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'widowed', 'STD_core_elements', 'marital_status', NULL, NULL, 'check_box', 'W - Widowed');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'seperated', 'STD_contact_field_record', 'marital_status', NULL, NULL, 'check_box', 'SEP - Separated');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'divorced', 'STD_contact_field_record', 'marital_status', NULL, NULL, 'check_box', 'D - Divorced');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'married', 'STD_contact_field_record', 'marital_status', NULL, NULL, 'check_box', 'M - Married');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'single', 'STD_contact_field_record', 'marital_status', NULL, NULL, 'check_box', 'S - Single, Never Married');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'widowed', 'STD_contact_field_record', 'marital_status', NULL, NULL, 'check_box', 'W - Widowed');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'current_male', 'STD_core_elements', 'current_gender', NULL, NULL, 'check_box', 'Male');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'current_male', 'STD_core_elements', 'current_gender', NULL, NULL, 'check_box', 'Female to Male Transgender');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'current_female', 'STD_core_elements', 'current_gender', NULL, NULL, 'check_box', 'Female');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'current_female', 'STD_core_elements', 'current_gender', NULL, NULL, 'check_box', 'Male to Female Transgender');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'gender_male', 'STD_core_elements', 'current_gender', NULL, NULL, 'check_box', 'Male');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'gender_female', 'STD_core_elements', 'current_gender', NULL, NULL, 'check_box', 'Female');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'male_to_female', 'STD_core_elements', 'current_gender', NULL, NULL, 'check_box', 'Male to Female Transgender');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'female_to_male', 'STD_core_elements', 'current_gender', NULL, NULL, 'check_box', 'Female to Male Transgender');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'alive', 'core', 'disease_event|died_id', 'yesno', NULL, 'check_box', 'N');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'alive', 'core', 'disease_event|died_id', 'yesno', NULL, 'check_box', '');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'dead', 'core', 'disease_event|died_id', 'yesno', NULL, 'check_box', 'Y');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'alive_unknown', 'core', 'disease_event|died_id', 'yesno', NULL, 'check_box', 'UNK');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'date_of_death', 'core', 'interested_party|person_entity|person|date_of_death', NULL, '  -  ', 'date_m_d_y', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'healthcare_worker_yes', 'core', 'interested_party|risk_factor|healthcare_worker_id', 'yesno', NULL, 'check_box', 'Y');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'healthcare_worker_no', 'core', 'interested_party|risk_factor|healthcare_worker_id', 'yesno', NULL, 'check_box', 'N');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', NULL, 'core', 'interested_party|risk_factor|healthcare_worker_id', 'yesno', NULL, 'push', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'occupation', 'core', 'interested_party|risk_factor|occupation', NULL, NULL, 'fill_if_yes', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'hispanic', 'core', 'interested_party|person_entity|person|ethnicity_id', 'ethnicity', NULL, 'check_box', 'H');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'not_hispanic', 'core', 'interested_party|person_entity|person|ethnicity_id', 'ethnicity', NULL, 'check_box', 'NH');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'ethnicity_unknown', 'core', 'interested_party|person_entity|person|ethnicity_id', 'ethnicity', NULL, 'check_box', 'UNK');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'american_indian', 'core', 'interested_party|person_entity|race_ids', 'race', NULL, 'check_box', 'AA');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'asian', 'core', 'interested_party|person_entity|race_ids', 'race', NULL, 'check_box', 'A');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'black', 'core', 'interested_party|person_entity|race_ids', 'race', NULL, 'check_box', 'B');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'hawaiian', 'core', 'interested_party|person_entity|race_ids', 'race', NULL, 'check_box', 'H');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'white', 'core', 'interested_party|person_entity|race_ids', 'race', NULL, 'check_box', 'W');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'race_unknown', 'core', 'interested_party|person_entity|race_ids', 'race', NULL, 'check_box', 'UNK');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'same_as_patient_address', 'STD_900_interview_record', 'address_at_dx', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', NULL, 'STD_900_interview_record', 'address_at_dx', NULL, NULL, 'push', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'address_diagnosis', 'STD_900_interview_record', 'street_add_at_dx', NULL, NULL, 'fill_if_no', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', NULL, 'STD_900_interview_record', 'address_at_dx', NULL, NULL, 'push', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'city_diagnosis', 'STD_900_interview_record', 'city_at_dx', NULL, NULL, 'fill_if_no', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', NULL, 'STD_900_interview_record', 'address_at_dx', NULL, NULL, 'push', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'county_diagnosis', 'STD_900_interview_record', 'county_at_dx', NULL, NULL, 'fill_if_no', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', NULL, 'STD_900_interview_record', 'address_at_dx', NULL, NULL, 'push', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'state_diagnosis', 'STD_900_interview_record', 'state_at_dx', NULL, NULL, 'fill_if_no', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', NULL, 'STD_900_interview_record', 'address_at_dx', NULL, NULL, 'push', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'zip_diagnosis', 'STD_900_interview_record', 'zip_at_dx', NULL, NULL, 'fill_if_no', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'facility_name', 'core', 'clinicians|person_entity|person|first_name', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'facility_name', 'core', 'clinicians|person_entity|person|middle_name', NULL, ' ', 'concat', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'facility_name', 'core', 'clinicians|person_entity|person|last_name', NULL, ' ', 'concat', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'facility_name', 'core', 'diagnostic_facilities|place_entity|place|name', NULL, NULL, 'replace_if_src_not_blank', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'person_completing_form', 'core', 'investigator|best_name', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_male_yes', 'std_risk_factors_assessment', 'sex_male_lt', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_male_no', 'std_risk_factors_assessment', 'sex_male_lt', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_male_unk', 'std_risk_factors_assessment', 'sex_male_lt', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_female_yes', 'std_risk_factors_assessment', 'sex_female_lt', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_female_no', 'std_risk_factors_assessment', 'sex_female_lt', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_female_unk', 'std_risk_factors_assessment', 'sex_female_lt', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'injected_yes', 'std_risk_factors_assessment', 'idu_lt', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'injected_no', 'std_risk_factors_assessment', 'idu_lt', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'injected_unk', 'std_risk_factors_assessment', 'idu_lt', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_drug_yes', 'std_risk_factors_assessment', 'idu_hetero_lt', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_drug_no', 'std_risk_factors_assessment', 'idu_hetero_lt', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_drug_unk', 'std_risk_factors_assessment', 'idu_hetero_lt', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_bisex_yes', 'std_risk_factors_assessment', 'bimale_hetero_lt', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_bisex_no', 'std_risk_factors_assessment', 'bimale_hetero_lt', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_bisex_unk', 'std_risk_factors_assessment', 'bimale_hetero_lt', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_hemo_yes', 'std_risk_factors_assessment', 'sex_coagulation_hetero', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_hemo_no', 'std_risk_factors_assessment', 'sex_coagulation_hetero', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_hemo_unk', 'std_risk_factors_assessment', 'sex_coagulation_hetero', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_transfusion_yes', 'std_risk_factors_assessment', 'sex_transfusion_hetero', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_transfusion_no', 'std_risk_factors_assessment', 'sex_transfusion_hetero', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_transfusion_unk', 'std_risk_factors_assessment', 'sex_transfusion_hetero', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_transplant_yes', 'std_risk_factors_assessment', 'sex_transplant_hetero', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_transplant_no', 'std_risk_factors_assessment', 'sex_transplant_hetero', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_transplant_unk', 'std_risk_factors_assessment', 'sex_transplant_hetero', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_aids_yes', 'std_risk_factors_assessment', 'sex_hiv_hetero', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_aids_no', 'std_risk_factors_assessment', 'sex_hiv_hetero', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'sex_aids_unk', 'std_risk_factors_assessment', 'sex_hiv_hetero', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'other_risk_yes', 'std_risk_factors_assessment', 'other_lt', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'other_risk_no', 'std_risk_factors_assessment', 'other_lt', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'other_risk_unk', 'std_risk_factors_assessment', 'other_lt', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'no_identified_risk_yes', 'std_risk_factors_assessment', 'nir', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'no_identified_risk_no', 'std_risk_factors_assessment', 'nir', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'no_identified_risk_unk', 'std_risk_factors_assessment', 'nir', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'clotting_yes', 'std_risk_factors_assessment', 'clottting_factor', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'clotting_no', 'std_risk_factors_assessment', 'clottting_factor', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'clotting_unk', 'std_risk_factors_assessment', 'clottting_factor', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'clotting_date', 'std_risk_factors_assessment', 'cf_dt_lt', NULL, '/', 'date_m_d_y', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'clotting_factor', 'std_risk_factors_assessment', 'cf_name_lt', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'transplant_yes', 'std_risk_factors_assessment', 'received_transplant', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'transplant_no', 'std_risk_factors_assessment', 'received_transplant', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'transplant_unk', 'std_risk_factors_assessment', 'received_transplant', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'transfusion_yes', 'std_risk_factors_assessment', 'received_transfusion', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'transfusion_no', 'std_risk_factors_assessment', 'received_transfusion', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'transfusion_unk', 'std_risk_factors_assessment', 'received_transfusion', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', '8th_grade', 'std_physical_desc', 'education', NULL, NULL, 'check_box', '8th grade or less');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'some_high_school', 'std_physical_desc', 'education', NULL, NULL, 'check_box', 'Some high school');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'high_school_degree', 'std_physical_desc', 'education', NULL, NULL, 'check_box', 'High school graduate or GED');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'some_college', 'std_physical_desc', 'education', NULL, NULL, 'check_box', 'Some college');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'college_degree', 'std_physical_desc', 'education', NULL, NULL, 'check_box', 'College degree');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'post_graduate', 'std_physical_desc', 'education', NULL, NULL, 'check_box', 'Post-graduate work');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'some_school', 'std_physical_desc', 'education', NULL, NULL, 'check_box', 'Some school, level unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'education_uknown', 'std_physical_desc', 'education', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'std_history', 'STD_core_elements', 'std_condition', NULL, '\n\n', 'multi_line', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'std_history_dates', 'STD_core_elements', 'std_dx_date', NULL, '\n\n', 'multi_line', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars', 'health_insurance', 'STD_core_elements', 'hlth_ins_type', NULL, NULL, 'replace_if_src_not_blank', NULL);

  
