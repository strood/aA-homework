class AddPollIdToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :poll_id, :integer, null: false
    add_index :questions, :poll_id
  end
end
