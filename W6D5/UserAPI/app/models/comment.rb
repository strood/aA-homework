# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  user_id    :integer          not null
#  artwork_id :integer          not null
#  body       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Comment < ApplicationRecord
  validates :user_id, presence: true #Could omit these two lines as rails auto
  validates :artwork_id, presence: true #<< checks if its an index, that its present
  validates :body, presence: true

  belongs_to :author,
             primary_key: :id,
             foreign_key: :user_id,
             class_name: :User

  belongs_to :artwork,
             primary_key: :id,
             foreign_key: :artwork_id,
             class_name: :Artwork

  has_many :likes,
           as: :imageable
end
