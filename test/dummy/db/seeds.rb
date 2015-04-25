require "faker"
1000.times do
  user = User.new
  user.first_name = Faker::Name.name
  user.last_name  = Faker::Name.name
  user.email = Faker::Internet.email
  user.birthdate = Faker::Date.between(7.days.ago, Time.zone.today)
  user.subscription_time = Faker::Time.between(7.days.ago, Time.zone.today)
  user.description = Faker::Lorem.paragraph(2)
  user.confirmed_at = Faker::Time.between(7.days.ago, Time.zone.today)
  user.save
end


3000.times do
  order = Order.new
  order.description = Faker::Lorem.paragraph(4)
  order.total = Faker::Commerce.price
  order.user = User.all.to_a.sample
  order.completed_at = [nil, Faker::Date.backward(50)].sample
  order.save
end
