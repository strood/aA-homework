class Like < ApplicationRecord
  validates :user_id, presence: true
  #   Below line redundant as its indexed so auto-checked by rails
  #   validates :imageable, presence: true

  belongs_to :liker,
             primary_key: :id,
             foreign_key: :user_id,
             class_name: :User

  belongs_to :imageable,
             polymorphic: true
end
