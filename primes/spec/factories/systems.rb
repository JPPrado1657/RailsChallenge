require 'faker'

FactoryBot.define do
  factory :system do
    name { Faker::Name.name }
  end
end