class CreateApplications < ActiveRecord::Migration[7.2]
  def change
    create_table :apps do |t|
      t.string :token
      t.string :name
      t.integer :chats_count, default: 0, null: false

      t.timestamps
    end
  end
end
