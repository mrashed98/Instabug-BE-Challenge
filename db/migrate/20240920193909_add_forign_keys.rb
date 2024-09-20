class AddForignKeys < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key "messages", "chats"
  end
end
