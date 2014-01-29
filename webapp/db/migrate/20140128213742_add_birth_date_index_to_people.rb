class AddBirthDateIndexToPeople < ActiveRecord::Migration
  def self.up
    add_index(:people, :birth_date)
  end

  def self.down
    remove_index(:people, :birth_date)
  end
end
