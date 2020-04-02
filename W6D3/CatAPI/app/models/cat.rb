class Cat < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :toys
end
