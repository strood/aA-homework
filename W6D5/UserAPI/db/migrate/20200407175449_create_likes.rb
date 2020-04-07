class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.integer :user_id, null: false
      # Two lines below shortened with the t.refernces form
      # t.bigint :imageable_id
      # t.string :imageable_type
      t.references :imageable, polymorphic: true

      t.timestamps
    end
    #This line is also eliminated when making the t.references shorthand.
    # add_index :likes, [:imageable_type, :imageable_id]
  end
end
