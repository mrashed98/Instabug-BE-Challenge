class ChangeColumnType < ActiveRecord::Migration[7.2]
  def change
    change_column :messages, :chat_id, :bigint
  end
end
