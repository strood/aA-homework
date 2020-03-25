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
  validate :no_spamming
  validate :nonpremium_max

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

  def no_spamming
    sub_past_min = ShortenedUrl.select(:id).where(created_at: (Time.now - 1.minute)..Time.now)
    unless sub_past_min.length <= 4
      errors[:user_id] << "User #{:user_id} has created too many URL's in the past minute, no spamming! (Max 5 per minute)"
    end
  end

  def nonpremium_max
    user = User.find_by(id: self.user_id)
    if user.submitted_urls.count >= 5 && !user.premium
      errors[:user_id] << "#{user.id} has created too many URL's for a non-premium member, must subscribe for more links (Max 5 per free user)"
    end
  end

  def self.random_code #generate random code to use as short_url, called in User.create!
    loop do
      code = SecureRandom::urlsafe_base64
      if !ShortenedUrl.exists?(:user_id => code)
        return code
        break
      end
    end
  end

  def self.prune(n)
    output = ShortenedUrl
      .joins(:submitter)
      .joins("LEFT JOIN visits ON visits.url_id = shortened_urls.id")
      .where("(shortened_urls.id IN (
      SELECT shortened_urls.id
      FROM shortened_urls
      JOIN visits
      ON visits.url_id = shortened_urls.id
      GROUP BY shortened_urls.id
      HAVING MAX(visits.created_at) < '#{n.minute.ago}'
    ) OR (
      visits.id IS NULL and shortened_urls.created_at < '#{n.minutes.ago}'
    )) AND users.premium = 'f'").destroy_all
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
