require 'faker'

# create test user
user = User.new(email: "test@user.com", first_name: "test", last_name: "user", address: nil, password: "123456")
user.save!

# create 10 pets
30.times do
  pet = Pet.new(name: Faker::Name.first_name , birth_date: Faker::Date.birthday(min_age: 1, max_age: 10), category: Pet::CATEGORIES.sample , gender: Pet::GENDERS.sample ,available: true, price_per_day: rand(1.1..49.9),address: Faker::Address.street_address)
  pet.user = user
  pet.save!
end


