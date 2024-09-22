class CreateChats < ActiveRecord::Migration[7.2]
  def change
    create_table :chats do |t|
      t.integer :number, default: 0, null: false
      t.string :application_token, null: false
      t.integer :messages_count

      t.timestamps
    end
  end
end
