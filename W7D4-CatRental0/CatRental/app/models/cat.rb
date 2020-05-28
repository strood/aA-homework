require "action_view"

class Cat < ApplicationRecord
  include ActionView::Helpers::DateHelper

  SEXES = [
    "M",
    "F",
  ].freeze

  COLORS = [
    "Black",
    "Brown",
    "White",
    "Grey",
    "Mixed",
  ].freeze

  validates :name, presence: true
  validates :birth_date, presence: true
  validates :color, presence: true
  validates :sex, presence: true
  validates :sex, inclusion: SEXES
  validates :color, inclusion: COLORS
  validates :owner, presence: true

  validate :birth_in_past, if: -> { birth_date }

  has_many :rental_requests,
           primary_key: :id,
           foreign_key: :cat_id,
           class_name: :CatRentalRequest,
           dependent: :destroy

  belongs_to :owner,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  def age
    time_ago_in_words(birth_date)
  end

  private

  def birth_in_past
    if birth_date && birth_date > Time.now
      errors[:birth_date] << "cant be in the future!"
    end
  end
end
