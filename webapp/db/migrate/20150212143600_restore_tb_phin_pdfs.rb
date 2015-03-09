class RestoreTbPhinPdfs < ActiveRecord::Migration
  def self.up
    drop_table :tb_phin_pdfs
    create_table :tb_phin_pdfs do |t|
    t.string :phin_var, :null => true
    t.string :pdf_var, :null => true
    t.string :page, :null => true
    t.integer :var_order, :null => true
    
      t.timestamps
    end
  
  #Locate db/phin_pdf_var.txt
  fileRoot = File.expand_path(File.dirname(__FILE__))
  modRoot = fileRoot.split(File::SEPARATOR).map {|x| x=="" ? File::SEPARATOR : x + File::SEPARATOR}
  modRoot.delete_at(-1)
  newPath = modRoot.join
  newPath = newPath + 'phin_pdf_var.txt'
  
  open(newPath) do |data_file|
    data_file.read.each_line do |line|
      phin_var, pdf_var, page, var_order = line.chomp.split("|")
      TbPhinPdf.create(:phin_var => phin_var, :pdf_var => pdf_var, :page => page, :var_order => var_order)
    end
  end
  end

  def self.down
  end
end
