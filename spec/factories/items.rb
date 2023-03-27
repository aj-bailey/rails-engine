FactoryBot.define do
  factory :item do
    name { Faker::Game.title }
    description { Faker::Game.genre }
    unit_price { Faker::Number.within(range: 1..100) }
    merchant
  end
end
