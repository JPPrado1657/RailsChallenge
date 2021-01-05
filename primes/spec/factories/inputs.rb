require 'faker'

FactoryBot.define do
  factory :input do
    input { Faker::Number.number(10) }
    output nil
    validInput false
    system_id nil
  end
end