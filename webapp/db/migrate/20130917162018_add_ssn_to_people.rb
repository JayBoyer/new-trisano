class AddSsnToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :ssn, :string, :limit => 11
  end

  def self.down
    remove_column :people, :ssn
  end
end
