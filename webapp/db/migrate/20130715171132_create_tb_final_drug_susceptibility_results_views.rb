class CreateTbFinalDrugSusceptibilityResultsViews < ActiveRecord::Migration
  def self.up
  execute %{
      CREATE OR REPLACE VIEW tb_final_drug_susceptibility_results_views AS    
        SELECT tb_qa_views.event_id, tb_qa_views.question_id, tb_qa_views.question_short_name, tb_qa_views.question_text, tb_qa_views.answer_id, tb_qa_views.answer_text, tb_qa_views.section_name, tb_qa_views.repeater_form_object_id, tb_qa_views.repeater_form_object_type, tb_qa_views.s_repeater, tb_qa_views.form_short_name, tb_qa_views.question_data_type, tb_qa_views.investigation_started_date, 
        CASE
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test'::text AND lower(tb_qa_views.answer_text::text) = 'isoniazid'::text THEN 'tb184'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test'::text AND lower(tb_qa_views.answer_text::text) = 'rifampin'::text THEN 'tb185'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test'::text AND lower(tb_qa_views.answer_text::text) = 'pyrazinamide'::text THEN 'tb186'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test'::text AND lower(tb_qa_views.answer_text::text) = 'ethambutol'::text THEN 'tb187'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test'::text AND lower(tb_qa_views.answer_text::text) = 'streptomycin'::text THEN 'tb188'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test'::text AND lower(tb_qa_views.answer_text::text) = 'rifabutin'::text THEN 'tb195'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test'::text AND lower(tb_qa_views.answer_text::text) = 'rifapentine'::text THEN 'tb295'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test'::text AND lower(tb_qa_views.answer_text::text) = 'ethionamide'::text THEN 'tb189'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test'::text AND lower(tb_qa_views.answer_text::text) = 'amikacin'::text THEN 'tb194'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test'::text AND lower(tb_qa_views.answer_text::text) = 'kanamycin'::text THEN 'tb190'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test'::text AND lower(tb_qa_views.answer_text::text) = 'capreomycin'::text THEN 'tb192'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test'::text AND lower(tb_qa_views.answer_text::text) = 'ciprofloxacin'::text THEN 'tb196'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test'::text AND lower(tb_qa_views.answer_text::text) = 'levofloxacin'::text THEN 'tb296'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test'::text AND lower(tb_qa_views.answer_text::text) = 'ofloxacin'::text THEN 'tb197'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test'::text AND lower(tb_qa_views.answer_text::text) = 'moxifloxacin'::text THEN 'tb297'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test'::text AND lower(tb_qa_views.answer_text::text) = 'other quinolones'::text THEN 'tb298'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test'::text AND lower(tb_qa_views.answer_text::text) = 'cycloserine'::text THEN 'tb191'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test'::text AND lower(tb_qa_views.answer_text::text) = 'para-amino salicylic acid'::text THEN 'tb193'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test'::text AND lower(tb_qa_views.answer_text::text) = 'other'::text THEN 'tb198_tb300'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_result'::text AND lower(tb_qa_views.answer_text::text) = 'resistant'::text THEN 'r'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_result'::text AND lower(tb_qa_views.answer_text::text) = 'susceptible'::text THEN 's'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_result'::text AND lower(tb_qa_views.answer_text::text) = 'not done'::text THEN 'nd'::text
            WHEN lower(tb_qa_views.question_short_name::text) = 'tb_drug_test_result'::text AND lower(tb_qa_views.answer_text::text) = 'unknown'::text THEN 'u'::text
            ELSE NULL::text
        END AS pdf_var
    FROM tb_qa_views tb_qa_views
    WHERE tb_qa_views.form_short_name::text = 'TB_case_completion'::text AND (tb_qa_views.question_short_name::text = ANY (ARRAY['TB_Drug_test'::character varying::text, 'TB_Drug_test_result'::character varying::text, 'other_drug_name'::character varying::text]))
    ORDER BY tb_qa_views.repeater_form_object_id, tb_qa_views.question_short_name;
    }
  end

  def self.down
  execute "drop view tb_final_drug_susceptibility_results_views;"
  end
end
