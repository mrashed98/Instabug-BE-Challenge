class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.bigint :chat_id, null: false
      t.integer :number
      t.text :body

      t.timestamps
    end
  end
end
