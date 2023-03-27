FactoryBot.define do
  factory :invoice do
    status { "Incomplete" }
    merchant 
    customer 
  end
end
