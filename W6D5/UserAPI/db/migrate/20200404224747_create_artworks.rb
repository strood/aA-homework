class CreateArtworks < ActiveRecord::Migration[5.2]
  def change
    create_table :artworks do |t|
      t.string :title, null: false
      t.string :image_url, null: false
      t.integer :artist_id, null: false

      t.timestamps
    end
    # This line below adds a db constraint on the pairing, so no duplicate shares of same art
    add_index :artworks, [:artist_id, :title], unique: true
  end
end
