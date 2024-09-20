class RenameChatsToChatCountInApps < ActiveRecord::Migration[7.2]
  def change
    rename_column :apps, :chats, :chats_count
  end
end
