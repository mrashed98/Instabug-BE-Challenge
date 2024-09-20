class AddUniqueIndexToChatsOnApplicationTokenAndNumber < ActiveRecord::Migration[7.2]
  def change
    remove_index :chats, name: "index_chats_on_application_token_and_number"

    add_index :chats, [ :application_token, :number ], unique: true
  end
end
