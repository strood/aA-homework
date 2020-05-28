class Cat < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :skill, presence: true

  has_many :toys
end
