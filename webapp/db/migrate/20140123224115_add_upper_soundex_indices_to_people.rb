class AddUpperSoundexIndicesToPeople < ActiveRecord::Migration
  def self.up
    transaction do
      execute("CREATE INDEX last_name_upper ON people USING btree (upper(last_name));")
      execute("CREATE INDEX first_name_upper ON people USING btree (upper(first_name));")
      execute("CREATE INDEX last_name_soundex ON people USING btree (soundex(last_name));")
      execute("CREATE INDEX first_name_soundex ON people USING btree (soundex(first_name));")
    end
  end

  def self.down
    transaction do
      execute("DROP INDEX last_name_upper ON people;")
      execute("DROP INDEX first_name_upper ON people;")
      execute("DROP INDEX last_name_soundex ON people;")
      execute("DROP INDEX first_name_soundex ON people;")
    end
  end
end
