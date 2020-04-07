# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  username   :string           not null
#
class User < ApplicationRecord
  validates :username, presence: true
  validates :username, uniqueness: true

  has_many :artworks,
           primary_key: :id,
           foreign_key: :artist_id,
           class_name: :Artwork

  has_many :artwork_share

  has_many :shared_artworks,
           through: :artwork_share,
           source: :artwork

  has_many :comments,
           primary_key: :id,
           foreign_key: :user_id,
           class_name: :Comment,
           dependent: :destroy

  has_many :likes,
           primary_key: :id,
           foreign_key: :user_id,
           class_name: :Like,
           dependent: :destroy
end
