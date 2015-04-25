FactoryGirl.define do
  factory :order, class: Order do
    total = Faker::Commerce.price
    user = User.all.to_a.sample
    completed_at = [nil, Faker::Date.backward(50)].sample
  end
end
