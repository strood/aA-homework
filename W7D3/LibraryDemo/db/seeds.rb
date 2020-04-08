# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveRecord::Base.transaction do
  Book.destroy_all
  100.times do
    Book.create!(title: Faker::Book.title, author: Faker::Book.author, year: Faker::Number.between(from: 1300, to:2020),category: Faker::Book.genre)
  end

end
