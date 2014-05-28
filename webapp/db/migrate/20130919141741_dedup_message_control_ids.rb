class DedupMessageControlIds < ActiveRecord::Migration
  def self.up
    message_control_id_dup = '0'
    i = 0
    StagedMessage.all(:order => "message_control_id").each do |m|
      if(m.message_control_id == message_control_id_dup)
        puts "de-duping ID: " + message_control_id_dup
        i += 1
        new_id = m.message_control_id + "-" + i.to_s
        if(m.hl7_message[m.message_control_id + "|P|"] != nil)
          hl7_message = String.new(m.hl7_message)
          hl7_message[m.message_control_id + "|P|"] = new_id + "|P|"
          m.hl7_message = hl7_message
        end
        m.message_control_id = new_id
        m.save(false)
      else
        message_control_id_dup = m.message_control_id
        i = 0
      end
    end
    remove_index :staged_messages, :message_control_id
    add_index :staged_messages, :message_control_id, :unique => true
  end

  def self.down
  end
end
