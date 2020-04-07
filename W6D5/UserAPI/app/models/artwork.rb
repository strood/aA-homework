# == Schema Information
#
# Table name: artworks
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  image_url  :string           not null
#  artist_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Artwork < ApplicationRecord
  validates :title, :image_url, :artist_id, presence: true
  validates :artist_id, uniqueness: { scope: :title }

  belongs_to :artist,
             primary_key: :id,
             foreign_key: :artist_id,
             class_name: :User

  has_many :artwork_share

  has_many :shared_viewers,
           through: :artwork_share,
           source: :viewer

  has_many :comments,
           primary_key: :id,
           foreign_key: :artwork_id,
           class_name: :Comment,
           dependent: :destroy

  has_many :likes,
           as: :imageable

  has_many :likers,
           through: :likes,
           source: :liker

  def self.artworks_for_user_id(user_id)
    Artwork
      .left_outer_joins(:artwork_share)
      .where("(artworks.artist_id = :user_id) OR (artwork_shares.user_id = :user_id)", user_id: user_id)
      .distinct
  end
end
