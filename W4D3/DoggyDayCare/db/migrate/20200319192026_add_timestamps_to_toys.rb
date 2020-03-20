class AddTimestampsToToys < ActiveRecord::Migration[6.0]
  def change
    add_column :toys, :created_at, :datetime, null: false
    add_column :toys, :updated_at, :datetime, null: false
  end
end
