class EditUserDetails < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :name, :string
    remove_column :users, :email, :string
    add_column :users, :username, :string, unique: true, null: false
    add_index :users, :username
  end
end
