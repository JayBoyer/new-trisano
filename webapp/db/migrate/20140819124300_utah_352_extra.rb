class Utah352Extra < ActiveRecord::Migration
  def self.up
    execute("ALTER TABLE lab_results ALTER COLUMN primary_lab_result SET NOT NULL")
    execute("ALTER TABLE users ALTER COLUMN status SET NOT NULL")
  end

  def self.down
  end
end
