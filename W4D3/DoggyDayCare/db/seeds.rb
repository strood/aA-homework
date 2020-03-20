require "faker"
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

p "Creating Houses"
House.destroy_all
house1 = House.create(name: "Big Blue House")
house2 = House.create(name: "The Shack")
house3 = House.create(name: "La Masion")

p "Creating Dogs"
Dog.destroy_all
dog1 = Dog.create(name: "Clifford", house_id: house2.id)
dog2 = Dog.create(name: "Snoopy", house_id: house1.id)

1000.times do
  Dog.create!(name: Faker::Name.last_name, house_id: house3.id)
end

p "Creating Toys"
Toy.destroy_all
toy1 = Toy.create(name: "big bone", color: "white", dog_id: dog1.id)
toy2 = Toy.create(name: "towel", color: "green", dog_id: dog1.id)
toy3 = Toy.create(name: "dog house", color: "red", dog_id: dog2.id)
toy4 = Toy.create(name: "blanket", color: "red", dog_id: dog2.id)
