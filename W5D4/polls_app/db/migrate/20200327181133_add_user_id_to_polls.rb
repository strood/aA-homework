class AddUserIdToPolls < ActiveRecord::Migration[6.0]
  def change
    add_column :polls, :user_id, :integer, null: false
    add_index :polls, :user_id
  end
end
