class CreateTbPhinQaSingleViews < ActiveRecord::Migration
  def self.up
	execute %{
      CREATE OR REPLACE VIEW tb_phin_qa_single_views AS 
        SELECT tb_qa_views.event_id, tb_qa_views.form_short_name, tb_qa_views.question_short_name, tb_qa_views.question_id, tb_qa_views.question_text, tb_qa_views.question_data_type, tb_qa_views.answer_text, tb_qa_views.investigation_started_date, 
        CASE
            WHEN lower(tb_qa_views.question_short_name::text) = 'born_us'::text THEN 'dem2003'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'count_date'::text THEN 'tb100'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'date_to_state'::text THEN 'inv177'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'city_limit'::text THEN 'tb099'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'country_born'::text THEN 'dem126'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'asian'::text THEN 'dem152_as_1'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'pacific_islander'::text THEN 'dem153'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_race'::text THEN 'dem152'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'arrive_us_date'::text THEN 'dem2005'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'county_case_no'::text THEN 'inv172_l'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'state_case_no'::text THEN 'inv173_l'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'state_case_no'::text THEN 'inv173_l'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_previous'::text THEN 'tb102'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'previous_tb_year'::text THEN 'tb103'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'smear_test'::text THEN 'tb110'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'smear_anatomic_code'::text THEN 'tb111'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'fluid_test_result'::text THEN 'tb113'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tissue_anatomic_code'::text THEN 'tb114'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'hiv_test_results'::text THEN 'tb122'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'state_hiv_pat_no'::text THEN 'tb125'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'county_hiv_pat_no'::text THEN 'tb126'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'homeless_pastyear'::text THEN 'tb127'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'jail_at_diagnosis'::text THEN 'tb128'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'facility'::text THEN 'tb129'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'ltc_resident'::text THEN 'tb130'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'ltc_type'::text THEN 'tb131'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'therapy_start_date'::text THEN 'tb147'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'ivdu_past_year'::text THEN 'tb148'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'non_ivdu_past_year'::text THEN 'tb149'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'alcohol_use_past_year'::text THEN 'tb150'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'iv_drug_use_history'::text THEN 'tb148a'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'drug_use_history'::text THEN 'tb149a'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'excessive_alcohol_use'::text THEN 'tb150a'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'count_status'::text THEN 'tb153'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'drug_suscept_test'::text THEN 'tb156'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'date_first_isolate_collect'::text THEN 'tb157'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'sputum_conversion'::text THEN 'tb173'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'date_first_neg_sputum'::text THEN 'tb175'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'therapy_end_date'::text THEN 'tb176'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'reason_therapy_stop'::text THEN 'tb177'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'outpatient_provider_type'::text THEN 'tb178'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'dot'::text THEN 'tb179'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'dot_weeks'::text THEN 'tb181'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'follow_up_drug_test'::text THEN 'tb182'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'date_final_isolate_collect'::text THEN 'tb183'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_site'::text THEN 'tb205'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_site_anatomic_code1'::text THEN 'tb205_1'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_site_anatomic_code2'::text THEN 'tb205_2'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_site_anatomic_code3'::text THEN 'tb205_3'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'patient_primary_occupation'::text THEN 'tb206'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'link_year_reported1'::text THEN 'tb207_y'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'link_state_code1'::text THEN 'tb207_s'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'link_case_number1'::text THEN 'tb207_l'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'link_year_reported2'::text THEN 'tb209_y'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'link_state_code2'::text THEN 'tb209_s'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'link_case_number2'::text THEN 'tb209_l'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'link_reason1'::text THEN 'tb208'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'link_reason2'::text THEN 'tb210'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_ini_country'::text THEN 'tb211'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'rvct_peds_foreign_2_mos'::text THEN 'tb215'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'country_lived'::text THEN 'tb216'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'rvct_cntry_birth_guardian_1'::text THEN 'tb217'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'rvct_cntry_birth_guardian_2'::text THEN 'tb218'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_death'::text THEN 'tb220'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'smear_collect_date'::text THEN 'tb228'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'smear_exam_type'::text THEN 'tb230'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'fluid_collect_date'::text THEN 'tb231'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'date_reported_fluid'::text THEN 'tb233'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'fluid_lab_type'::text THEN 'tb234'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'naa_test_result'::text THEN 'tb235'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'naa_collect_date'::text THEN 'tb236'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'naa_Specimen_type'::text THEN 'tb238'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'naa_anatomic_code'::text THEN 'tb239'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'naa_result_date'::text THEN 'tb240'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'naa_lab_type'::text THEN 'tb242'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_evaluated_reason'::text THEN 'tb254'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'immi_enforce'::text THEN 'tb256'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'additional_tb_risk'::text THEN 'tb257'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'other_tb_risk'::text THEN 'tb258'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'immigration_status'::text THEN 'tb259'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'genotyping'::text THEN 'tb266'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'genotyping_no'::text THEN 'tb267'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'specimen_type'::text THEN 'tb268'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'anatomic_code'::text THEN 'tb269'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'reason_not_doc_sputum_conversion'::text THEN 'tb277'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'other_reason_not_doc_conversion'::text THEN 'tb278'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'moved'::text THEN 'tb279'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'moved_to_where'::text THEN 'tb280'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'transnational_referral'::text THEN 'tb281'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'move_county'::text THEN 'tb282'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'move_county2'::text THEN 'tb284'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'move_state'::text THEN 'tb286_1'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'move_state2'::text THEN 'tb286_2'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'country'::text THEN 'tb288_1'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'move_country2'::text THEN 'tb288_2'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'cause_of_death'::text THEN 'tb290'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'reason_therapy_12_mon'::text THEN 'tb291'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'other_reason_therapy'::text THEN 'tb292'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'sputum_specimen'::text THEN 'tb293'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'non_sputum_anatomic_code'::text THEN 'tb294'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'comments'::text THEN 'pg5_comm_pg6_comm'::text
            ELSE NULL::text
        END AS phin_var, tb_qa_views.answer_code
		FROM tb_qa_views tb_qa_views
		WHERE tb_qa_views.s_repeater IS NOT TRUE AND tb_qa_views.form_short_name::text ~~ 'TB%'::text;
    }
  end

  def self.down
	execute "drop view tb_phin_qa_single_views;"
  end
end
