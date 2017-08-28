#TODO jay
require "#{Rails.root}/app/models/staged_message"

class PopulateMessageControlIds < ActiveRecord::Migration
  def self.up
   StagedMessage.all.each do |m|
     hl7 = HL7::Message.new(m.hl7_message)
     m.message_control_id = hl7[:MSH].message_control_id
     m.save(false)
   end
   execute 'ALTER TABLE staged_messages ALTER COLUMN message_control_id SET NOT NULL;'
   add_index :staged_messages, :message_control_id, :unique => true
  end

  def self.down
  end
end
