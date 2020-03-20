# == Schema Information
#
# Table name: houses
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class House < ApplicationRecord
  has_many :dogs,
    primary_key: :id,
    foreign_key: :house_id,
    class_name: :Dog

  has_many :toys,
           through: :dogs,
           source: :toys

  # The long way below, we can do this better above^
  #   def toys
  #     toys = []

  #     # self.dogs or dogs
  #     dogs.each do |dog|
  #       toys.concat(dog.toys)
  #     end

  #     toys
  #   end
end
