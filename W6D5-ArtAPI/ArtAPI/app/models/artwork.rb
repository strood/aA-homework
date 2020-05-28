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
#  favorite   :boolean          default(FALSE)
#
class Artwork < ApplicationRecord
  validates :title, :image_url, :artist_id, presence: true
  validates :image_url, uniqueness: true
  validates :artist_id, uniqueness: { scope: :title }
  validates :favorite, inclusion: { in: [true, false] }

  belongs_to :artist,
             primary_key: :id,
             foreign_key: :artist_id,
             class_name: :User

  has_many :artwork_shares

  has_many :shared_viewers,
           through: :artwork_shares,
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

  has_many :artwork_collections,
           primary_key: :id,
           foreign_key: :artwork_id,
           class_name: :ArtworkCollection

  def self.artworks_for_user_id(user_id)
    Artwork
      .left_outer_joins(:artwork_shares)
      .where("(artworks.artist_id = :user_id) OR (artwork_shares.user_id = :user_id)", user_id: user_id)
      .distinct
  end

  def self.artworks_for_collection_id(collection_id)
    Artwork.joins(:artwork_collections).where(artwork_collections: { collection_id: collection_id })
  end
end
