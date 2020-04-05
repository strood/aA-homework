# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ActiveRecord::Base.transaction do
  User.destroy_all
  user1 = User.create!(username: "Brenda")
  user2 = User.create!(username: "Kevin")
  user3 = User.create!(username: "Ramsay")
  user4 = User.create!(username: "Karen")
  user5 = User.create!(username: "Eliza")
  user6 = User.create!(username: "Beth")
  user7 = User.create!(username: "George")
  user8 = User.create!(username: "Paul")
  user9 = User.create!(username: "Stacey")
  user10 = User.create!(username: "Brent")

  Artwork.destroy_all
  a1 = Artwork.create!(title: "Big Bird", image_url: "getart.com/big_bird", artist_id: user1.id)
  a2 = Artwork.create!(title: "Sail Away", image_url: "getart.com/sail_away", artist_id: user1.id)
  a3 = Artwork.create!(title: "Dog Pond", image_url: "artguy.com/dog_pond", artist_id: user1.id)
  a4 = Artwork.create!(title: "Diglet", image_url: "getart.com/pokemon/diglet", artist_id: user2.id)
  a5 = Artwork.create!(title: "Spaces", image_url: "getart.com/spaces", artist_id: user4.id)
  a6 = Artwork.create!(title: "Regional Carnage", image_url: "bigideas.com/carnage", artist_id: user5.id)
  a7 = Artwork.create!(title: "Con Artist", image_url: "artguy.com/con-artist", artist_id: user6.id)
  a8 = Artwork.create!(title: "Washed Up Walkman", image_url: "getart.com/washed_up", artist_id: user7.id)
  a9 = Artwork.create!(title: "Trees in Winter Sun", image_url: "getart.com/landscape/tree", artist_id: user8.id)
  a10 = Artwork.create!(title: "Wrong Way Jackson", image_url: "artsy.com/Jack", artist_id: user8.id)

  ArtworkShare.destroy_all
  as1 = ArtworkShare.create!(user_id: user10.id, artwork_id: a3.id)
  as1 = ArtworkShare.create!(user_id: user9.id, artwork_id: a3.id)
  as1 = ArtworkShare.create!(user_id: user1.id, artwork_id: a3.id)
  as1 = ArtworkShare.create!(user_id: user4.id, artwork_id: a3.id)
  as1 = ArtworkShare.create!(user_id: user7.id, artwork_id: a3.id)
  as1 = ArtworkShare.create!(user_id: user3.id, artwork_id: a4.id)
  as1 = ArtworkShare.create!(user_id: user2.id, artwork_id: a1.id)
  as1 = ArtworkShare.create!(user_id: user1.id, artwork_id: a2.id)
  as1 = ArtworkShare.create!(user_id: user5.id, artwork_id: a5.id)
  as1 = ArtworkShare.create!(user_id: user1.id, artwork_id: a6.id)
  as1 = ArtworkShare.create!(user_id: user9.id, artwork_id: a7.id)
  as1 = ArtworkShare.create!(user_id: user2.id, artwork_id: a8.id)
  as1 = ArtworkShare.create!(user_id: user3.id, artwork_id: a9.id)
  as1 = ArtworkShare.create!(user_id: user8.id, artwork_id: a10.id)
  as1 = ArtworkShare.create!(user_id: user9.id, artwork_id: a10.id)
  as1 = ArtworkShare.create!(user_id: user6.id, artwork_id: a9.id)
  as1 = ArtworkShare.create!(user_id: user1.id, artwork_id: a8.id)
  as1 = ArtworkShare.create!(user_id: user2.id, artwork_id: a5.id)
  as1 = ArtworkShare.create!(user_id: user3.id, artwork_id: a8.id)
  as1 = ArtworkShare.create!(user_id: user3.id, artwork_id: a7.id)
  as1 = ArtworkShare.create!(user_id: user10.id, artwork_id: a6.id)
  as1 = ArtworkShare.create!(user_id: user10.id, artwork_id: a2.id)
  as1 = ArtworkShare.create!(user_id: user9.id, artwork_id: a2.id)
  as1 = ArtworkShare.create!(user_id: user5.id, artwork_id: a1.id)
  as1 = ArtworkShare.create!(user_id: user4.id, artwork_id: a1.id)
end
