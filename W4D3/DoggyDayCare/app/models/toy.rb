# == Schema Information
#
# Table name: toys
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  dog_id     :integer          not null
#  color      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Toy < ApplicationRecord
  #Written in a classic manner, not with Rails Associations
  # def dog
  #     Dog.find(dog_id)
  # end

  belongs_to :dog,
    primary_key: :id,
    foreign_key: :dog_id,  #from toys tble
    class_name: :Dog

  has_one :house,
    through: :dog,
    source: :house
end
