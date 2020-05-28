class AddUserToCatRentalRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :cat_rental_requests, :user_id, :integer, default:1, null: false
    add_index :cat_rental_requests, :user_id
  end
end
