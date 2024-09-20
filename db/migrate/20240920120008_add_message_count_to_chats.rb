class AddMessageCountToChats < ActiveRecord::Migration[7.2]
  def change
    add_column :chats, :messages_count, :int
  end
end
