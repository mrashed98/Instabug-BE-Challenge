class AddIndexs < ActiveRecord::Migration[7.2]
  def change
    add_index :messages, [ :chat_id, :number ], unique: true
    add_index :chats, [ :application_token, :number ], unique: true
    add_index :apps, :token, unique: true
  end
end
