class ChangeAppsColumnToApplicationTokenInChats < ActiveRecord::Migration[7.2]
  def change
     # Remove the old foreign key and index
     remove_foreign_key :chats, :apps, column: :apps_id
     remove_index :chats, name: "index_chats_on_apps_id"

     # Rename the column from apps_id to application_token and change its type
     rename_column :chats, :apps_id, :application_token
     change_column :chats, :application_token, :string

     # Add a new index on application_token
     add_index :chats, [ :application_token, :number ]
  end
end
