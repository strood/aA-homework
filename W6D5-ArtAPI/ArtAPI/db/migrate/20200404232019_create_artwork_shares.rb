class CreateArtworkShares < ActiveRecord::Migration[5.2]
  def change
    create_table :artwork_shares do |t|
      t.integer :user_id, null: false
      t.integer :artwork_id, null: false

      t.timestamps
    end
    # This line below adds a db constraint on the pairing, so no duplicate shares of same art
    add_index :artwork_shares, [:user_id, :artwork_id], unique: true
  end
end
