class AddIndexToToysTable < ActiveRecord::Migration[6.0]
  def change
    add_index :toys, :name
    add_index :toys, :dog_id
  end
end
