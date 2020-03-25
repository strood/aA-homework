# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  premium    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  validates :email, presence: true
  validates :email, uniqueness: true

  has_many :submitted_urls,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :ShortenedUrl

  has_many :visits,
           primary_key: :id,
           foreign_key: :user_id,
           class_name: :Visit

  has_many :visited_urls,
           through: :visits,
           source: :url

  has_many :distinct_visited_urls,
           -> { distinct },
           through: :visits,
           source: :url

  def create_url!(long_url) #create a new shortened url and save to db, given a long url, called on user.
    shortened = ShortenedUrl.new(long_url: long_url, user_id: self.id)
    shortened.short_url = "short.n/" + ShortenedUrl.random_code[0..4]
    shortened.save!
  end

  def upgrade
    self.premium = true
    self.save!
  end

  def downgrade
    self.premium = false
    self.save!
  end
end
