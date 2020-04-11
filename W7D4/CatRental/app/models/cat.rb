require 'action_view'

class Cat < ApplicationRecord
  include ActionView::Helpers::DateHelper

  SEXES = [
    "M",
    "F"
  ]
  COLORS = [
    "Black",
    "Brown",
    "White",
    "Grey",
    "Mixed"
  ]
  validates :name, presence: true
  validates :birth_date, presence: true
  validates :color, presence: true
  validates :sex, presence: true
  validates :sex, inclusion: SEXES
  validates :color, inclusion: COLORS


  def age
    time_ago_in_words(birth_date)
  end


end
