class CreateHouses < ActiveRecord::Migration[6.0]
  def change
    create_table :houses do |t|
      t.string :name, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end
end
