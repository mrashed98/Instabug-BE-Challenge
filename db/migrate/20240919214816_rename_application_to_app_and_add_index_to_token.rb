class RenameApplicationToAppAndAddIndexToToken < ActiveRecord::Migration[7.2]
  def change
    rename_table :applications, :apps

    add_index :apps, :token, unique: true
    # Ex:- add_index("admin_users", "username")
  end
end
