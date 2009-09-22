class AddElrFields < ActiveRecord::Migration
  def self.up
    add_column :staged_messages, :patient_last_name,  :string
    add_column :staged_messages, :patient_first_name, :string
    add_column :staged_messages, :laboratory_name,    :string
  end

  def self.down
    remove_column :staged_messages, :patient_last_name
    remove_column :staged_messages, :patient_first_name
    remove_column :staged_messages, :laboratory_name
  end
end
