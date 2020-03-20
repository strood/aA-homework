class AddTimestampsToDogs < ActiveRecord::Migration[6.0]
  def change
    add_column :dogs, :created_at, :datetime, null: false
    add_column :dogs, :updated_at, :datetime, null: false
  end
end
