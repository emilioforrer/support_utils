FactoryGirl.define do
  factory :user, class: User do
    first_name Faker::Name.name
    last_name  Faker::Name.name
    email Faker::Internet.email
    birthdate Faker::Date.between(7.days.ago, Time.zone.today)
    subscription_time Faker::Time.between(7.days.ago, Time.zone.today)
    description Faker::Lorem.paragraph(2)
    confirmed_at Faker::Time.between(7.days.ago, Time.zone.today)
  end
end
