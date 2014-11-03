class CreateTbInitialDrugSusceptibilityResultsViews < ActiveRecord::Migration
  def self.up
	execute %{
      CREATE OR REPLACE VIEW tb_initial_drug_susceptibility_results_views AS 
        SELECT tb_qa_views.event_id, tb_qa_views.question_id, tb_qa_views.question_short_name, tb_qa_views.question_text, tb_qa_views.answer_id, tb_qa_views.answer_text, tb_qa_views.section_name, tb_qa_views.repeater_form_object_id, tb_qa_views.repeater_form_object_type, tb_qa_views.s_repeater, tb_qa_views.form_short_name, tb_qa_views.question_data_type, tb_qa_views.investigation_started_date, 
        CASE
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_init'::text AND lower(tb_qa_views.answer_text::text) = 'isoniazid'::text THEN 'tb158'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_init'::text AND lower(tb_qa_views.answer_text::text) = 'rifampin'::text THEN 'tb159'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_init'::text AND lower(tb_qa_views.answer_text::text) = 'pyrazinamide'::text THEN 'tb160'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_init'::text AND lower(tb_qa_views.answer_text::text) = 'ethambutol'::text THEN 'tb161'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_init'::text AND lower(tb_qa_views.answer_text::text) = 'streptomycin'::text THEN 'tb162'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_init'::text AND lower(tb_qa_views.answer_text::text) = 'rifabutin'::text THEN 'tb169'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_init'::text AND lower(tb_qa_views.answer_text::text) = 'rifapentine'::text THEN 'tb270'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_init'::text AND lower(tb_qa_views.answer_text::text) = 'ethionamide'::text THEN 'tb163'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_init'::text AND lower(tb_qa_views.answer_text::text) = 'amikacin'::text THEN 'tb168'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_init'::text AND lower(tb_qa_views.answer_text::text) = 'kanamycin'::text THEN 'tb164'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_init'::text AND lower(tb_qa_views.answer_text::text) = 'capreomycin'::text THEN 'tb166'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_init'::text AND lower(tb_qa_views.answer_text::text) = 'ciprofloxacin'::text THEN 'tb170'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_init'::text AND lower(tb_qa_views.answer_text::text) = 'levofloxacin'::text THEN 'tb271'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_init'::text AND lower(tb_qa_views.answer_text::text) = 'ofloxacin'::text THEN 'tb171'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_init'::text AND lower(tb_qa_views.answer_text::text) = 'moxifloxacin'::text THEN 'tb272'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_init'::text AND lower(tb_qa_views.answer_text::text) = 'other quinolones'::text THEN 'tb273'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_init'::text AND lower(tb_qa_views.answer_text::text) = 'cycloserine'::text THEN 'tb165'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_init'::text AND lower(tb_qa_views.answer_text::text) = 'para-amino salicylic acid'::text THEN 'tb167'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_init'::text AND lower(tb_qa_views.answer_text::text) = 'other'::text THEN 'tb172_tb275'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_result_init'::text AND lower(tb_qa_views.answer_text::text) = 'resistant'::text THEN 'r'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_result_init'::text AND lower(tb_qa_views.answer_text::text) = 'susceptible'::text THEN 's'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_result_init'::text AND lower(tb_qa_views.answer_text::text) = 'not done'::text THEN 'nd'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_result_init'::text AND lower(tb_qa_views.answer_text::text) = 'unknown'::text THEN 'u'::text
            ELSE NULL::text
        END AS pdf_var
		FROM tb_qa_views tb_qa_views
		WHERE lower(tb_qa_views.form_short_name::text) = 'tb_drug_susceptibility_test'::text AND (lower(tb_qa_views.question_short_name::text) = ANY (ARRAY['tb_drug_test_init'::character varying::text, 'tb_drug_test_result_init'::character varying::text, 'other_drug_name_init'::character varying::text]))
		ORDER BY tb_qa_views.repeater_form_object_id, tb_qa_views.question_short_name;
    }
  end

  def self.down
	execute "drop view tb_initial_drug_susceptibility_results_views;"
  end
end
