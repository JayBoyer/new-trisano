# Implement the DB changes that Utah has added to their version
#

class IncreaseLabResultsValueSize < ActiveRecord::Migration
  def self.up
  
    change_table(:lab_results) do |t|
      change_col_length('lab_results', 'result_value', 10485760)
    end
    
  end

  def self.down
    change_table(:lab_results) do |t|
      change_col_length('lab_results', 'result_value', 255)
    end
  end

  
  def self.change_col_length(table, column, length=0)
    col_tmp = column+"_tmp"
    change_table(table) do |t|
      t.string col_tmp, :limit => length
    end
	execute "UPDATE #{table} SET #{col_tmp} = #{column}"
    change_table(table) do |t|
      t.remove column
    end
    rename_column table, col_tmp, column
  end  
end
