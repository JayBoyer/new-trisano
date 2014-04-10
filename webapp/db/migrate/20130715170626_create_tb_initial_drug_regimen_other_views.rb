class CreateTbInitialDrugRegimenOtherViews < ActiveRecord::Migration
  def self.up
  execute %{
      CREATE OR REPLACE VIEW tb_initial_drug_regimen_other_views AS 
 SELECT qa.event_id, qa.answer_text AS drug_name, qa.repeater_form_object_id AS repeat_id, t.id AS treatment_id, t.treatment_name, pt.treatment_date, ec.the_code AS status, 
        CASE
            WHEN lower(t.treatment_name::text) = 'other'::text AND ec.the_code::text = 'Y'::text THEN 'tb146_tb264_y'::text
            WHEN lower(t.treatment_name::text) = 'other'::text AND ec.the_code::text = 'N'::text THEN 'tb146_tb264_n'::text
            WHEN lower(t.treatment_name::text) = 'other'::text AND ec.the_code::text = 'UNK'::text THEN 'tb146_tb264_u'::text
            ELSE NULL::text
        END AS pdf_var
   FROM tb_qa_views qa
   LEFT JOIN participations_treatments pt ON pt.id = qa.repeater_form_object_id
   LEFT JOIN treatments t ON t.id = pt.treatment_id
   LEFT JOIN external_codes ec ON pt.treatment_given_yn_id = ec.id
   WHERE pt.treatment_id IS NOT NULL AND lower(t.treatment_name::text) = 'other'::text AND qa.repeater_form_object_type::text = 'ParticipationsTreatment'::text AND qa.question_short_name::text = 'other_treatment'::text;
    }
  end

  def self.down
   execute "drop view tb_initial_drug_regimen_other_views;"
  end
end
