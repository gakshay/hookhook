# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


wishlist = Wishlist.where(name: "Top 10 people").first_or_create do |list|
  list.description = "people I'd like to talk to!"
  list.status = 0
  list.limit = 10
end

wishlist.description = "people I'd like to talk to!"
wishlist.save!

