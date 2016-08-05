class GeneratePdfMappings < ActiveRecord::Migration
  def self.up
    create_table :generate_pdf_mappings do |t|
      t.string :template_pdf_name, :null => false
      t.string :template_field_name
      t.string :form_short_name, :null => false
      t.string :form_field_name, :null => false
      t.string :code_name
      t.string :concat_string
      t.string :operation
      t.string :match_value
    end

    add_index :generate_pdf_mappings, :template_pdf_name
  end

  def self.down
    drop_table :generate_pdf_mappings
  end
end
