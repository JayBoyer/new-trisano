class AddLegacyIdToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :std_legacy_id, :string, :limit => 20
  end

  def self.down
    remove_column :people, :std_legacy_id
  end
end
