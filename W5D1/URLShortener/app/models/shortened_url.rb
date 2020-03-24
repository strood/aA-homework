# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint           not null, primary key
#  long_url   :string           not null
#  short_url  :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ShortenedUrl < ApplicationRecord
  validates :long_url, presence: true
  validates :short_url, presence: true
  validates :short_url, uniqueness: true
  validates :user_id, presence: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Visit

  has_many :visitors,
    through: :visits,
    source: :user

  has_many :distinct_visitors,
           -> { distinct },
           through: :visits,
           source: :user

  has_many :tags,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Tagging

  has_many :tag_topics,
    through: :tags,
    source: :topic

  def self.random_code #generate random code to use as short_url, called in User.create!
    loop do
      code = SecureRandom::urlsafe_base64
      if !ShortenedUrl.exists?(:user_id => code)
        return code
        break
      end
    end
  end

  def num_clicks
    self.visits.count
  end

  def num_uniques
    self.distinct_visitors.length #bc i changed the relation above with distinct, can shorten this
                                  #instad of doing like above and filtering .distinct.
  end

  def num_recent_uniques
    visits = Visit.select(:user_id, :created_at).distinct.where(created_at: (Time.now - 10.minute)..Time.now)
    visits.length
  end
end
