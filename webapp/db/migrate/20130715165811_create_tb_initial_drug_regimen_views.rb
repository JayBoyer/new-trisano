class CreateTbInitialDrugRegimenViews < ActiveRecord::Migration
  def self.up
  execute %{
      CREATE OR REPLACE VIEW tb_initial_drug_regimen_views AS  
        SELECT e.id AS event_id, e.event_name, e.event_onset_date, pt.treatment_id, t.treatment_name, ec.the_code AS status, pt.treatment_date, 
        CASE
            WHEN lower(t.treatment_name::text) = 'isoniazid'::text AND ec.the_code::text = 'Y'::text THEN 'tb132_y'::text
            WHEN lower(t.treatment_name::text) = 'isoniazid'::text AND ec.the_code::text = 'N'::text THEN 'tb132_n'::text
            WHEN lower(t.treatment_name::text) = 'isoniazid'::text AND ec.the_code::text = 'UNK'::text THEN 'tb132_u'::text
            WHEN lower(t.treatment_name::text) = 'rifampin'::text AND ec.the_code::text = 'Y'::text THEN 'tb133_y'::text
            WHEN lower(t.treatment_name::text) = 'rifampin'::text AND ec.the_code::text = 'N'::text THEN 'tb133_n'::text
            WHEN lower(t.treatment_name::text) = 'rifampin'::text AND ec.the_code::text = 'UNK'::text THEN 'tb133_u'::text
            WHEN lower(t.treatment_name::text) = 'pyrazinamide'::text AND ec.the_code::text = 'Y'::text THEN 'tb134_y'::text
            WHEN lower(t.treatment_name::text) = 'pyrazinamide'::text AND ec.the_code::text = 'N'::text THEN 'tb134_n'::text
            WHEN lower(t.treatment_name::text) = 'pyrazinamide'::text AND ec.the_code::text = 'UNK'::text THEN 'tb134_u'::text
            WHEN lower(t.treatment_name::text) = 'ethambutol'::text AND ec.the_code::text = 'Y'::text THEN 'tb135_y'::text
            WHEN lower(t.treatment_name::text) = 'ethambutol'::text AND ec.the_code::text = 'N'::text THEN 'tb135_n'::text
            WHEN lower(t.treatment_name::text) = 'ethambutol'::text AND ec.the_code::text = 'UNK'::text THEN 'tb135_u'::text
            WHEN lower(t.treatment_name::text) = 'streptomycin'::text AND ec.the_code::text = 'Y'::text THEN 'tb136_y'::text
            WHEN lower(t.treatment_name::text) = 'streptomycin'::text AND ec.the_code::text = 'N'::text THEN 'tb136_n'::text
            WHEN lower(t.treatment_name::text) = 'streptomycin'::text AND ec.the_code::text = 'UNK'::text THEN 'tb136_u'::text
            WHEN lower(t.treatment_name::text) = 'rifabutin'::text AND ec.the_code::text = 'Y'::text THEN 'tb143_y'::text
            WHEN lower(t.treatment_name::text) = 'rifabutin'::text AND ec.the_code::text = 'N'::text THEN 'tb143_n'::text
            WHEN lower(t.treatment_name::text) = 'rifabutin'::text AND ec.the_code::text = 'UNK'::text THEN 'tb143_u'::text
            WHEN lower(t.treatment_name::text) = 'rifapentine'::text AND ec.the_code::text = 'Y'::text THEN 'tb260_y'::text
            WHEN lower(t.treatment_name::text) = 'rifapentine'::text AND ec.the_code::text = 'N'::text THEN 'tb260_n'::text
            WHEN lower(t.treatment_name::text) = 'rifapentine'::text AND ec.the_code::text = 'UNK'::text THEN 'tb260_u'::text
            WHEN lower(t.treatment_name::text) = 'ethionamide'::text AND ec.the_code::text = 'Y'::text THEN 'tb137_y'::text
            WHEN lower(t.treatment_name::text) = 'ethionamide'::text AND ec.the_code::text = 'N'::text THEN 'tb137_n'::text
            WHEN lower(t.treatment_name::text) = 'ethionamide'::text AND ec.the_code::text = 'UNK'::text THEN 'tb137_u'::text
            WHEN lower(t.treatment_name::text) = 'amikacin'::text AND ec.the_code::text = 'Y'::text THEN 'tb142_y'::text
            WHEN lower(t.treatment_name::text) = 'amikacin'::text AND ec.the_code::text = 'N'::text THEN 'tb142_n'::text
            WHEN lower(t.treatment_name::text) = 'amikacin'::text AND ec.the_code::text = 'UNK'::text THEN 'tb142_u'::text
            WHEN lower(t.treatment_name::text) = 'kanamycin'::text AND ec.the_code::text = 'Y'::text THEN 'tb138_y'::text
            WHEN lower(t.treatment_name::text) = 'kanamycin'::text AND ec.the_code::text = 'N'::text THEN 'tb138_n'::text
            WHEN lower(t.treatment_name::text) = 'kanamycin'::text AND ec.the_code::text = 'UNK'::text THEN 'tb138_u'::text
            WHEN lower(t.treatment_name::text) = 'capreomycin'::text AND ec.the_code::text = 'Y'::text THEN 'tb140_y'::text
            WHEN lower(t.treatment_name::text) = 'capreomycin'::text AND ec.the_code::text = 'N'::text THEN 'tb140_n'::text
            WHEN lower(t.treatment_name::text) = 'capreomycin'::text AND ec.the_code::text = 'UNK'::text THEN 'tb140_u'::text
            WHEN lower(t.treatment_name::text) = 'ciprofloxacin'::text AND ec.the_code::text = 'Y'::text THEN 'tb144_y'::text
            WHEN lower(t.treatment_name::text) = 'ciprofloxacin'::text AND ec.the_code::text = 'N'::text THEN 'tb144_n'::text
            WHEN lower(t.treatment_name::text) = 'ciprofloxacin'::text AND ec.the_code::text = 'UNK'::text THEN 'tb144_u'::text
            WHEN lower(t.treatment_name::text) = 'levofloxacin'::text AND ec.the_code::text = 'Y'::text THEN 'tb261_y'::text
            WHEN lower(t.treatment_name::text) = 'levofloxacin'::text AND ec.the_code::text = 'N'::text THEN 'tb261_n'::text
            WHEN lower(t.treatment_name::text) = 'levofloxacin'::text AND ec.the_code::text = 'UNK'::text THEN 'tb261_u'::text
            WHEN lower(t.treatment_name::text) = 'ofloxacin'::text AND ec.the_code::text = 'Y'::text THEN 'tb145_y'::text
            WHEN lower(t.treatment_name::text) = 'ofloxacin'::text AND ec.the_code::text = 'N'::text THEN 'tb145_n'::text
            WHEN lower(t.treatment_name::text) = 'ofloxacin'::text AND ec.the_code::text = 'UNK'::text THEN 'tb145_u'::text
            WHEN lower(t.treatment_name::text) = 'moxifloxacin'::text AND ec.the_code::text = 'Y'::text THEN 'tb262_y'::text
            WHEN lower(t.treatment_name::text) = 'moxifloxacin'::text AND ec.the_code::text = 'N'::text THEN 'tb262_n'::text
            WHEN lower(t.treatment_name::text) = 'moxifloxacin'::text AND ec.the_code::text = 'UNK'::text THEN 'tb262_u'::text
            WHEN lower(t.treatment_name::text) = 'cycloserine'::text AND ec.the_code::text = 'Y'::text THEN 'tb139_y'::text
            WHEN lower(t.treatment_name::text) = 'cycloserine'::text AND ec.the_code::text = 'N'::text THEN 'tb139_n'::text
            WHEN lower(t.treatment_name::text) = 'cycloserine'::text AND ec.the_code::text = 'UNK'::text THEN 'tb139_u'::text
            WHEN lower(t.treatment_name::text) = 'para-amino salicylic acid'::text AND ec.the_code::text = 'Y'::text THEN 'tb141_y'::text
            WHEN lower(t.treatment_name::text) = 'para-amino salicylic acid'::text AND ec.the_code::text = 'N'::text THEN 'tb141_n'::text
            WHEN lower(t.treatment_name::text) = 'para-amino salicylic acid'::text AND ec.the_code::text = 'UNK'::text THEN 'tb141_u'::text
            ELSE NULL::text
        END AS pdf_var
    FROM events e
    LEFT JOIN participations p ON p.event_id = e.id
    LEFT JOIN participations_treatments pt ON pt.participation_id = p.id
    LEFT JOIN treatments t ON t.id = pt.treatment_id
    LEFT JOIN external_codes ec ON pt.treatment_given_yn_id = ec.id
    WHERE pt.treatment_id IS NOT NULL
    ORDER BY e.id, pt.treatment_date;
    }
  end

  def self.down
  execute "drop view tb_initial_drug_regimen_views;"
  end
end
