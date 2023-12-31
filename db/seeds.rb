# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

700_000.times do |i|
  if User.create(id: i, update_me_quickly: 'some text', email: Faker::Internet.email, name: Faker::Name.name, age: rand(1..100), sex: [0, 1].sample, display_name: Faker::Internet.username(specifier: 3..3), bio: "some really cool bio", state: 'NY', preferences_hash: JSON.generate(User.default_preferences))
    puts "user #{i}"
  end
end