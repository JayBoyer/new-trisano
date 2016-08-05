INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'patient_name', 'core', 'interested_party|person_entity|person|first_name', NULL, ' ', NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'patient_name', 'core', 'interested_party|person_entity|person|middle_name', NULL, ' ', 'concat', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'patient_name', 'core', 'interested_party|person_entity|person|last_name', NULL, ' ', 'concat', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'date_of_birth', 'core', 'interested_party|person_entity|person|birth_date', NULL, '  -  ', 'date_m_d_y', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'alias', 'STD_core_elements', 'aka', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'phone_number', 'core', 'interested_party|person_entity|telephones|area_code', NULL, ' ', NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'phone_number', 'core', 'interested_party|person_entity|telephones|phone_number', NULL, '-', 'concat', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'phone_number', 'core', 'interested_party|person_entity|telephones|extension', NULL, ' x', 'concat', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value)
  VALUES ('hars_pediatric', 'address', 'core', 'address|street_number', NULL, ' ', NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'address', 'core', 'address|street_name', NULL, ' ', 'concat', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'address', 'core', 'address|unit_number', NULL, ' #', 'concat', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'city', 'core', 'address|city', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'zip_code', 'core', 'address|postal_code', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'county', 'core', 'address|county_id', 'county', NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'state', 'core', 'address|state_id', 'state', NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'disease_aids_infection', 'core', 'disease_event|disease_id', NULL, NULL, 'check_box', '49');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'disease_aids_infection', 'core', 'disease_event|disease_id', NULL, NULL, 'check_box', '164');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'disease_hiv_infection', 'core', 'disease_event|disease_id', NULL, NULL, 'check_box', '53');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'disease_hiv_infection', 'core', 'disease_event|disease_id', NULL, NULL, 'check_box', '54');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'disease_hiv_infection', 'core', 'disease_event|disease_id', NULL, NULL, 'check_box', '165');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'disease_hiv_infection', 'core', 'disease_event|disease_id', NULL, NULL, 'check_box', '166');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'disease_hiv_infection', 'core', 'disease_event|disease_id', NULL, NULL, 'check_box', '169');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'disease_hiv_infection', 'core', 'disease_event|disease_id', NULL, NULL, 'check_box', '184');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'birth_sex_male', 'core', 'interested_party|person_entity|person|birth_gender_id', 'gender', NULL, 'check_box', 'M');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'birth_sex_female', 'core', 'interested_party|person_entity|person|birth_gender_id', 'gender', NULL, 'check_box', 'F');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'birth_sex_unknown', 'core', 'interested_party|person_entity|person|birth_gender_id', 'gender', NULL, 'check_box', 'U');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'state_patient_number', 'std_ehars_ID', 'hars_stateno', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', NULL, 'core', 'interested_party|person_entity|person|birth_date', NULL, NULL, 'push', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'hiv_age_diagnosis', 'std_ehars_ID', 'hiv_dx_dt', NULL, NULL, 'age_subtract', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', NULL, 'core', 'interested_party|person_entity|person|birth_date', NULL, NULL, 'push', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'aids_age_diagnosis', 'std_ehars_ID', 'aids_dx_dt', NULL, NULL, 'age_subtract', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'birth_us', 'STD_core_elements', 'country_birth', NULL, NULL, 'check_box', '');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'birth_other', 'STD_core_elements', 'country_birth', NULL, NULL, 'check_box_invert', '');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'social_security_number', 'STD_core_elements', 'ssn', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'birth_country', 'STD_core_elements', 'country_birth', NULL, NULL, NULL, NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'seperated', 'STD_interview_record', 'marital_status', NULL, NULL, 'check_box', 'SEP - Separated');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'divorced', 'STD_interview_record', 'marital_status', NULL, NULL, 'check_box', 'D - Divorced');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'married', 'STD_interview_record', 'marital_status', NULL, NULL, 'check_box', 'M - Married');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'single', 'STD_interview_record', 'marital_status', NULL, NULL, 'check_box', 'S - Single, Never Married');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'widowed', 'STD_interview_record', 'marital_status', NULL, NULL, 'check_box', 'W - Widowed');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'current_male', 'STD_interview_record', 'current_gender', NULL, NULL, 'check_box', 'Male');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'current_male', 'STD_interview_record', 'current_gender', NULL, NULL, 'check_box', 'Female to Male Transgender');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'current_female', 'STD_interview_record', 'current_gender', NULL, NULL, 'check_box', 'Female');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'current_female', 'STD_interview_record', 'current_gender', NULL, NULL, 'check_box', 'Male to Female Transgender');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'gender_male', 'STD_interview_record', 'current_gender', NULL, NULL, 'check_box', 'Male');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'gender_female', 'STD_interview_record', 'current_gender', NULL, NULL, 'check_box', 'Male');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'male_to_female', 'STD_interview_record', 'current_gender', NULL, NULL, 'check_box', 'Male to Female Transgender');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'female_to_male', 'STD_interview_record', 'current_gender', NULL, NULL, 'check_box', 'Female to Male Transgender');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'alive', 'core', 'disease_event|died_id', 'yesno', NULL, 'check_box', 'N');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'alive', 'core', 'disease_event|died_id', 'yesno', NULL, 'check_box', '');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'dead', 'core', 'disease_event|died_id', 'yesno', NULL, 'check_box', 'Y');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'alive_unknown', 'core', 'disease_event|died_id', 'yesno', NULL, 'check_box', 'UNK');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'date_of_death', 'core', 'interested_party|person_entity|person|date_of_death', NULL, '  -  ', 'date_m_d_y', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'healthcare_worker_yes', 'core', 'interested_party|risk_factor|healthcare_worker_id', 'yesno', NULL, 'check_box', 'Y');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'healthcare_worker_no', 'core', 'interested_party|risk_factor|healthcare_worker_id', 'yesno', NULL, 'check_box', 'N');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', NULL, 'core', 'interested_party|risk_factor|healthcare_worker_id', 'yesno', NULL, 'push', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'occupation', 'core', 'interested_party|risk_factor|occupation', NULL, NULL, 'fill_if_yes', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'hispanic', 'core', 'interested_party|person_entity|person|ethnicity_id', 'ethnicity', NULL, 'check_box', 'H');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'not_hispanic', 'core', 'interested_party|person_entity|person|ethnicity_id', 'ethnicity', NULL, 'check_box', 'NH');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'ethnicity_unknown', 'core', 'interested_party|person_entity|person|ethnicity_id', 'ethnicity', NULL, 'check_box', 'UNK');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'american_indian', 'core', 'interested_party|person_entity|race_ids', 'race', NULL, 'check_box', 'AA');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'asian', 'core', 'interested_party|person_entity|race_ids', 'race', NULL, 'check_box', 'A');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'black', 'core', 'interested_party|person_entity|race_ids', 'race', NULL, 'check_box', 'B');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'hawaiian', 'core', 'interested_party|person_entity|race_ids', 'race', NULL, 'check_box', 'H');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'white', 'core', 'interested_party|person_entity|race_ids', 'race', NULL, 'check_box', 'W');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'race_unknown', 'core', 'interested_party|person_entity|race_ids', 'race', NULL, 'check_box', 'UNK');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'same_as_patient_address', 'STD_900_interview_record', 'address_at_dx', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', NULL, 'STD_900_interview_record', 'address_at_dx', NULL, NULL, 'push', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'address_diagnosis', 'STD_900_interview_record', 'street_add_at_dx', NULL, NULL, 'fill_if_no', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', NULL, 'STD_900_interview_record', 'address_at_dx', NULL, NULL, 'push', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'city_diagnosis', 'STD_900_interview_record', 'city_at_dx', NULL, NULL, 'fill_if_no', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', NULL, 'STD_900_interview_record', 'address_at_dx', NULL, NULL, 'push', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'county_diagnosis', 'STD_900_interview_record', 'county_at_dx', NULL, NULL, 'fill_if_no', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', NULL, 'STD_900_interview_record', 'address_at_dx', NULL, NULL, 'push', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'state_diagnosis', 'STD_900_interview_record', 'state_at_dx', NULL, NULL, 'fill_if_no', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', NULL, 'STD_900_interview_record', 'address_at_dx', NULL, NULL, 'push', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'zip_diagnosis', 'STD_900_interview_record', 'zip_at_dx', NULL, NULL, 'fill_if_no', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_male_yes', 'std_risk_factors_assessment', 'sex_male_lt', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_male_no', 'std_risk_factors_assessment', 'sex_male_lt', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_male_unk', 'std_risk_factors_assessment', 'sex_male_lt', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_female_yes', 'std_risk_factors_assessment', 'sex_female_lt', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_female_no', 'std_risk_factors_assessment', 'sex_female_lt', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_female_unk', 'std_risk_factors_assessment', 'sex_female_lt', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'injected_yes', 'std_risk_factors_assessment', 'idu_lt', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'injected_no', 'std_risk_factors_assessment', 'idu_lt', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'injected_unk', 'std_risk_factors_assessment', 'idu_lt', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_drug_yes', 'std_risk_factors_assessment', 'idu_hetero_lt', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_drug_no', 'std_risk_factors_assessment', 'idu_hetero_lt', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_drug_unk', 'std_risk_factors_assessment', 'idu_hetero_lt', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_bisex_yes', 'std_risk_factors_assessment', 'bimale_hetero_lt', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_bisex_no', 'std_risk_factors_assessment', 'bimale_hetero_lt', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_bisex_unk', 'std_risk_factors_assessment', 'bimale_hetero_lt', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_hemo_yes', 'std_risk_factors_assessment', 'sex_coagulation_hetero', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_hemo_no', 'std_risk_factors_assessment', 'sex_coagulation_hetero', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_hemo_unk', 'std_risk_factors_assessment', 'sex_coagulation_hetero', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_transfusion_yes', 'std_risk_factors_assessment', 'sex_transfusion_hetero', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_transfusion_no', 'std_risk_factors_assessment', 'sex_transfusion_hetero', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_transfusion_unk', 'std_risk_factors_assessment', 'sex_transfusion_hetero', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_transplant_yes', 'std_risk_factors_assessment', 'sex_transplant_hetero', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_transplant_no', 'std_risk_factors_assessment', 'sex_transplant_hetero', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_transplant_unk', 'std_risk_factors_assessment', 'sex_transplant_hetero', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_aids_yes', 'std_risk_factors_assessment', 'sex_hiv_hetero', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_aids_no', 'std_risk_factors_assessment', 'sex_hiv_hetero', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'sex_aids_unk', 'std_risk_factors_assessment', 'sex_hiv_hetero', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'other_risk_yes', 'std_risk_factors_assessment', 'other_lt', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'other_risk_no', 'std_risk_factors_assessment', 'other_lt', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'other_risk_unk', 'std_risk_factors_assessment', 'other_lt', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'no_identified_risk_yes', 'std_risk_factors_assessment', 'nir', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'no_identified_risk_no', 'std_risk_factors_assessment', 'nir', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'no_identified_risk_unk', 'std_risk_factors_assessment', 'nir', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', '8th_grade', 'std_physical_desc', 'education', NULL, NULL, 'check_box', '8th grade or less');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'some_high_school', 'std_physical_desc', 'education', NULL, NULL, 'check_box', 'Some high school');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'high_school_degree', 'std_physical_desc', 'education', NULL, NULL, 'check_box', 'High school graduate or GED');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'some_college', 'std_physical_desc', 'education', NULL, NULL, 'check_box', 'Some college');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'college_degree', 'std_physical_desc', 'education', NULL, NULL, 'check_box', 'College degree');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'post_graduate', 'std_physical_desc', 'education', NULL, NULL, 'check_box', 'Post-graduate work');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'some_school', 'std_physical_desc', 'education', NULL, NULL, 'check_box', 'Some school, level unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'education_uknown', 'std_physical_desc', 'education', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'std_history', 'STD_core_elements', 'std_condition', NULL, '\n\n', 'multi_line', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'std_history_dates', 'STD_core_elements', 'std_dx_date', NULL, '\n\n', 'multi_line', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'perinatal_hiv_exposure', 'core', 'disease_event|disease_id', NULL, NULL, 'check_box', '166');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'pediatric_hiv', 'core', 'disease_event|disease_id', NULL, NULL, 'check_box', '54');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'pediatric_aids', 'core', 'disease_event|disease_id', NULL, NULL, 'check_box', '164');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'pediatric_seroreverter', 'core', 'disease_event|disease_id', NULL, NULL, 'check_box', '165');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'candidiasis', 'STD_900_interview_record', 'dis_name', NULL, NULL, 'check_box', 'Candidiasis, bronchi, trachea, or lungs');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'date_candidiasis', 'STD_900_interview_record', 'initial_dt', NULL, '/', 'date_m_d_y', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'clotting_yes', 'std_risk_factors_assessment', 'clottting_factor', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'clotting_no', 'std_risk_factors_assessment', 'clottting_factor', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'clotting_unk', 'std_risk_factors_assessment', 'clottting_factor', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'clotting_date', 'std_risk_factors_assessment', 'cf_dt_lt', NULL, '/', 'date_m_d_y', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'transplant_yes', 'std_risk_factors_assessment', 'received_transplant', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'transplant_no', 'std_risk_factors_assessment', 'received_transplant', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'transplant_unk', 'std_risk_factors_assessment', 'received_transplant', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'transfusion_yes', 'std_risk_factors_assessment', 'received_transfusion', NULL, NULL, 'check_box', 'Yes');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'transfusion_no', 'std_risk_factors_assessment', 'received_transfusion', NULL, NULL, 'check_box', 'No');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'transfusion_unk', 'std_risk_factors_assessment', 'received_transfusion', NULL, NULL, 'check_box', 'Unknown');
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'transfusion_first_date', 'std_risk_factors_assessment', 'transfusion_first_dt', NULL, '/', 'date_m_d_y', NULL);
INSERT INTO generate_pdf_mappings(template_pdf_name, template_field_name, form_short_name, form_field_name, code_name, concat_string, operation, match_value) 
  VALUES ('hars_pediatric', 'transfusion_last_date', 'std_risk_factors_assessment', 'transfusion_last_dt', NULL, '/', 'date_m_d_y', NULL);
  
