class CreateTbQaViews < ActiveRecord::Migration
  def self.up
  execute %{
      CREATE OR REPLACE VIEW tb_qa_views AS 
         SELECT a.event_id, a.question_id, q.short_name AS question_short_name, q.question_text, a.id AS answer_id, a.text_answer AS answer_text, s.name AS section_name, a.repeater_form_object_id, a.repeater_form_object_type, s.repeater AS s_repeater, f.short_name AS form_short_name, q.data_type AS question_data_type, e.investigation_started_date, a.code AS answer_code
      FROM answers a
      LEFT JOIN questions q ON q.id = a.question_id
      LEFT JOIN form_elements fe ON q.form_element_id = fe.id
        LEFT JOIN form_elements s ON s.id = fe.parent_id
        LEFT JOIN forms f ON f.id = fe.form_id
        LEFT JOIN events e ON e.id = a.event_id
        ORDER BY a.event_id, f.short_name, s.name, a.repeater_form_object_id, a.question_id;
    }
  end

  def self.down
  execute "drop view tb_qa_views;"
  end
end
