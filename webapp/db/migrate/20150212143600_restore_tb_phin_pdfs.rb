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
      id = 1
      data_file.read.each_line do |line|
        phin_var, pdf_var, page, var_order = line.chomp.split("|")
        if(var_order.nil?) 
           execute("INSERT INTO tb_phin_pdfs(id, phin_var, pdf_var, page) VALUES (" +
              id.to_s + ",'" + phin_var + "','" + pdf_var + "','" + page + "')")
        else
           execute("INSERT INTO tb_phin_pdfs(id, phin_var, pdf_var, page, var_order) VALUES (" +
              id.to_s + ",'" + phin_var + "','" + pdf_var + "','" + page + "','" + var_order + "')")
        end
        id += 1
      end
    end
  end

  def self.down
  end
end
