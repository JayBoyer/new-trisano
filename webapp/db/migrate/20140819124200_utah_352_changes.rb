# Implement the DB changes that Utah has added to their version
#

class Utah352Changes < ActiveRecord::Migration
  def self.up
    drop_dependent_views
    change_table(:addresses) do |t|
      t.decimal :latitude, :precision => 9, :scale => 6
      t.decimal :longitude, :precision => 9, :scale => 6
    end
    change_column :addresses, :street_name, :string, :limit => 250
    create_table(:alert_subscriptions) do |t|
      t.string :alert_type, :limit => 255
      t.integer :owner_id, :null => false
      t.text :subject
      t.timestamps      
    end
    create_table(:alert_subscriptions_dashboard_recipients) do |t|
      t.integer :alert_subscription_id, :dashboard_recipient_id, :null => false
    end
    create_table(:alert_subscriptions_diseases) do |t|
      t.integer :alert_subscription_id, :disease_id, :null => false
      t.timestamps
    end
    create_table(:alert_subscriptions_email_addresses) do |t|
      t.integer :alert_subscription_id, :email_address_id, :null => false
      t.timestamps
    end
    create_table(:alert_subscriptions_jurisdictions) do |t|
      t.integer :alert_subscription_id, :jurisdiction_id, :null => false
      t.timestamps
    end
    change_table(:answers) do |t|
      t.integer :outbreak_id
    end
    upgrade_col_string_unlimited("answers", "text_answer")
    change_table(:attachments) do |t|
      t.integer :master_id, :outbreak_id, :outbreak_update_id
    end
    create_table(:audit_user) do |t|
      t.timestamp :action_date
      t.text :audit_action, :audit_data
      t.integer :event_id, :outbreak_id, :user_id      
    end
    create_table(:core_element) do |t|
      t.integer :core_section_id, :core_tab_id, :data_set_type_id, :export_field_id, :input_size, :input_type_id,
        :maxlength, :parent_section_id, :seq, :ui_element_type_id
      t.boolean :export_filter, :new_line, :required
      t.text :core_validator, :description, :help_text, :label, :xpath      
    end
    create_table(:core_section) do |t|
      t.integer :parent_id, :seq, :type
      t.text :label, :name
      t.boolean :export
    end
    create_table(:dashboard_alerts) do |t|
      t.integer :event_id
      t.integer :recipient_id, :null => false
      t.string :alert_type, :limit => 255
      t.text :message, :subject
      t.text :status, :null => false, :default => 'new'
      t.timestamp :event_at
      t.timestamps
    end
    change_table(:disease_events) do |t|
      t.integer :date_diagnosed_type_id
    end
    change_table(:entities) do |t|
      t.integer :merged_into_entity_id
      t.text :merge_effected_events
    end
    change_table(:events) do |t|
      t.date :lhd_date_closed, :lhd_investigation_start_date, :outbreak_date
      t.integer :outbreak_event_id, :outbreak_id, :disposition_id
      t.text :outbreak_description
    end
    create_table(:export_fields) do |t|
      t.integer :core_field_id, :sort_order, :type
      t.string :collection, :event_type, :export_group, :long_name, :short_name, :use_code, :use_description, :limit => 255
      t.boolean :disease_specific, :default => false
      t.text :qry_name, :qry_name_select, :qry_name_where
      t.timestamps
    end
    upgrade_col_string_unlimited("form_elements", "description")
    change_table(:form_references) do |t|
      t.integer :outbreak_id
    end
    create_table(:lab_names) do |t|
      t.integer :record_num
    end
    execute "ALTER TABLE lab_names ADD COLUMN clabs character varying"
    execute "ALTER TABLE lab_names ADD COLUMN lab character varying"
    change_table(:lab_results) do |t|
      t.boolean :primary_lab_result, :default => false
    end
	execute "UPDATE lab_results SET primary_lab_result = false"
    create_table(:outbreak_access) do |t|
      t.integer :jurisdiction_id, :outbreak_id, :null => false
      t.integer :type, :null => false, :default => 1
    end
    create_table(:outbreak_report_sections) do |t|
      t.integer :outbreak_id, :report_section_id, :user_id
      t.text :report_text
      t.timestamp :created_at
    end
    create_table(:outbreak_updates) do |t|
      t.integer :outbreak_id, :user_id
      t.integer :type, :null => false, :default => 0
      t.text :description
      t.timestamp :created_at
    end
    create_table(:outbreaks) do |t|
      t.integer :created_user_id, :disease_id, :investigator_id, :jurisdiction_id, :parent_id,
        :report_approved_user_id, :source_event_id
      t.integer :location_type, :null => false, :default => 1
      t.integer :status, :null => false, :default => 0
      t.boolean :report_required
      t.boolean :link_to_epi_tracker, :null => false, :default => false
      t.boolean :report_approved, :null => false, :default => false
      t.string :name, :null => false, :limit => 200
      t.string :number, :limit => 200
      t.text :description, :epi_tracker_name, :report_reason, :report_reason_other
      t.timestamp :outbreak_date, :report_approved_date
      t.timestamps
    end
    change_table(:participations_treatments) do |t|
      t.text :treatment_comment
    end
    change_table(:people) do |t|
      t.boolean :live, :default => true
      t.integer :next_ver, :previous_ver
    end
    change_table(:places) do |t|
      t.boolean :primary
    end
    upgrade_col_string_unlimited("questions", "help_text")
    upgrade_col_string_unlimited("questions", "question_text")
    create_table(:report_sections) do |t|
      t.text :description
    end
    create_table(:system_messages) do |t|
      t.text :message, :null => false
      t.timestamp :expires_on
      t.timestamps
    end
    create_table(:user_export_columns) do |t|
      t.integer :comparison_type, :core_element_id, :filter_greater, :filter_less, :question_id, :seq, :user_export_id
      t.boolean :filter_include_nulls
      t.boolean :has_filter, :null => false, :default => false
      t.boolean :show, :null => false, :default => true
      t.text :column_name, :compare_to_value, :value_in_list
      t.timestamp :filter_before, :filter_after
    end
    create_table(:user_export_diseases) do |t|
      t.integer :disease_id, :user_export_id
    end
    create_table(:user_export_folder) do |t|
      t.integer :folder_type, :parent_id, :user_id
      t.text :name
    end
    create_table(:user_export_history) do |t|
      t.integer :export_record_count, :user_export_id, :user_id
      t.text :user_export_xml
      t.timestamp :created_at, :null => false
    end
    create_table(:user_exports) do |t|
      t.integer :user_export_folder_id, :user_id
      t.boolean :include_deleted
      t.boolean :group_count, :null => false, :default => false
      t.boolean :private_export, :null => false, :default => true
      t.text :file_name, :name
      t.timestamps
    end
    change_table(:users) do |t|
      t.text :events_view_settings
      t.timestamp :last_login 
    end
    execute "ALTER TABLE users ADD COLUMN dashboard_settings character varying"
    execute "ALTER TABLE users ADD COLUMN task_settings character varying"
	execute "UPDATE users SET status = '' WHERE status is NULL"
#TODO    create_dependent_views
  end

  def self.down
#TODO    drop_dependent_views
    change_table(:addresses) do |t|
      t.remove :latitude, :longitude
    end
    change_column :addresses, :street_name, :string, :limit => 50
    drop_table(:alert_subscriptions)
    drop_table(:alert_subscriptions_dashboard_recipients)
    drop_table(:alert_subscriptions_diseases)
    drop_table(:alert_subscriptions_email_addresses)
    drop_table(:alert_subscriptions_jurisdictions)
    change_table(:answers) do |t|
      t.remove :outbreak_id
    end
    downgrade_col_to_string_fixed("answers", "text_answer", 10485760)
    change_table(:attachments) do |t|
      t.remove :master_id, :outbreak_id, :outbreak_update_id
    end
    drop_table(:audit_user)
    drop_table(:core_element)
    drop_table(:core_section)
    drop_table(:dashboard_alerts)
    change_table(:disease_events) do |t|
      t.remove :date_diagnosed_type_id
    end
    change_table(:entities) do |t|
      t.remove :merged_into_entity_id, :merge_effected_events
    end
    change_table(:events) do |t|
      t.remove :lhd_date_closed, :lhd_investigation_start_date, :outbreak_date, :outbreak_event_id, 
        :outbreak_id, :disposition_id, :outbreak_description
    end
    drop_table(:export_fields)
    downgrade_col_to_string_fixed("form_elements", "description", 10485760)
    change_table(:form_references) do |t|
      t.remove :outbreak_id
    end
    drop_table(:lab_names)
    change_table(:lab_results) do |t|
      t.remove :primary_lab_result
    end
    drop_table(:outbreak_access)
    drop_table(:outbreak_report_sections)
    drop_table(:outbreak_updates)
    drop_table(:outbreaks)
    change_table(:participations_treatments) do |t|
      t.remove :treatment_comment
    end
    change_table(:people) do |t|
      t.remove :live, :next_ver, :previous_ver
    end
    change_table(:places) do |t|
      t.remove :primary
    end
    downgrade_col_to_string_fixed("questions", "help_text", 10485760)
    downgrade_col_to_string_fixed("questions", "question_text", 10485760)
    drop_table(:report_sections)
    drop_table(:system_messages)
    drop_table(:user_export_columns)
    drop_table(:user_export_diseases)
    drop_table(:user_export_folder)
    drop_table(:user_export_history)
    drop_table(:user_exports)
    change_table(:users) do |t|
      t.remove :dashboard_settings, :events_view_settings, :task_settings, :last_login
    end
  end
  
  def self.upgrade_col_string_unlimited(table, column)
    upgrade_downgrade_col(true, table, column)
  end
  
  def self.downgrade_col_to_string_fixed(table, column, length)
    upgrade_downgrade_col(false, table, column, length)
  end
  
  def self.upgrade_downgrade_col(upgrade, table, column, length=0)
    col_tmp = column+"_tmp"
    change_table(table) do |t|
      if(upgrade)
        execute "ALTER TABLE #{table} ADD COLUMN #{col_tmp} character varying"
      else
        t.string col_tmp, :limit => length
      end
    end
	execute "UPDATE #{table} SET #{col_tmp} = #{column}"
    change_table(table) do |t|
      t.remove column
    end
    rename_column table, col_tmp, column
  end
  
  def self.drop_dependent_views
	execute "DROP VIEW IF EXISTS clinician "
	execute "DROP VIEW IF EXISTS hepatitis"
	execute "DROP VIEW IF EXISTS interested_parties"
	execute "DROP VIEW IF EXISTS table_link"
	execute "DROP VIEW IF EXISTS vw_recent_flu"
	execute "DROP VIEW IF EXISTS tb_final_drug_susceptibility_results_views"
	execute "DROP VIEW IF EXISTS tb_initial_drug_regimen_other_views;"
	execute "DROP VIEW IF EXISTS tb_initial_drug_regimen_views;"
	execute "DROP VIEW IF EXISTS tb_initial_drug_susceptibility_results_views;"
	execute "DROP VIEW IF EXISTS tb_phin_qa_single_views;"
	execute "DROP VIEW IF EXISTS tb_qa_views;"
  end
end
