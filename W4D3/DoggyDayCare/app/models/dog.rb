# == Schema Information
#
# Table name: dogs
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  house_id   :integer
#
class Dog < ApplicationRecord
  validates :name, presence: true
  validates :house_id, presence: true
  validate :check_name_length

  #classic style below, not written with Rails Associations
  #   def toys
  #     Toy.where({ dog_id: self.id})
  #   end

  has_many :toys,
           primary_key: :id,     #dogs id
           foreign_key: :dog_id,
           class_name: :Toy

  belongs_to :house,
             primary_key: :id,     #dogs id
             foreign_key: :house_id,  #from dogs tble
             class_name: :House

  def check_name_length
    unless self.name.length >= 2
      errors[:name] << "Name is too short, must be equal to or longer than 2 chars"
    end
  end

  def self.lookup_name_in_ms(name)
    start = Time.now
    Dog.where(name: name)
    (Time.now - start) * 1000
  end
end
