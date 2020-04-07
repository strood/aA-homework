class Like < ApplicationRecord
  validates :user_id, presence: true
  #   Below line redundant as its indexed so auto-checked by rails
  #   validates :imageable, presence: true

  belongs_to :imageable,
             polymorphic: true
end
