# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


default_wishlist = Wishlist.create(name: 'Top 10 people',
                                   description: "List of top 10 people that you will like to meet",
                                   status: 0,
                                   limit: 10
)
