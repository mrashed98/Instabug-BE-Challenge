class AddForignKeys < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key :chats, :apps, column: :application_token, primary_key: :token
    add_foreign_key :messages, :chats, column: :chat_id
  end
end
