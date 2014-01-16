class AddLegacyIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :legacy_id, :string, :limit => 10
  end

  def self.down
    remove_column :user, :legacy_id
  end
end
