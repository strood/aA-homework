# == Schema Information
#
# Table name: polls
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Poll < ApplicationRecord
  # Remember, Rails 5 automatically validates the presence of belongs_to associations.
  validates :title, presence: true
  #   validates :user_id, presence: true

  belongs_to :author,
             primary_key: :id,
             foreign_key: :user_id,
             class_name: :User

  has_many :questions,
           primary_key: :id,
           foreign_key: :poll_id,
           class_name: :Question
end
