class AddMessageControlIdToStagedMessages < ActiveRecord::Migration
  def self.up
   add_column :staged_messages, :message_control_id, :string
  end

  def self.down
   remove_column :staged_messages, :message_control_id
  end
end
