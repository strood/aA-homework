# == Schema Information
#
# Table name: likes
#
#  id             :bigint           not null, primary key
#  user_id        :integer          not null
#  imageable_type :string
#  imageable_id   :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Like < ApplicationRecord
  validates :user_id, uniqueness: { scope: [:imageable_id, :imageable_type] }
  #   Below line redundant as its indexed so auto-checked by rails
  #   validates :imageable, presence: true

  belongs_to :liker,
             primary_key: :id,
             foreign_key: :user_id,
             class_name: :User

  belongs_to :imageable,
             polymorphic: true
end
