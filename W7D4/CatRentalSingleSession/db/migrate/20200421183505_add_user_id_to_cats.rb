class AddUserIdToCats < ActiveRecord::Migration[5.2]
  def change
    # WIll have to do a new migrate later to get rid of default
    add_column :cats, :user_id, :integer, default: 1, null: false
    add_index :cats, :user_id
  end
end
