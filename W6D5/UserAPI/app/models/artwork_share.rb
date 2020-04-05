# == Schema Information
#
# Table name: artwork_shares
#
#  id         :bigint           not null, primary key
#  user_id    :integer          not null
#  artwork_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ArtworkShare < ApplicationRecord
  validates :user_id, :artwork_id, presence: true
  validates :user_id, uniqueness: { scope: :artwork_id }

  belongs_to :viewer,
             primary_key: :id,
             foreign_key: :user_id,
             class_name: :User

  belongs_to :artwork,
             primary_key: :id,
             foreign_key: :artwork_id,
             class_name: :Artwork
end
