FactoryGirl.define do
  factory :tooltip do
    slug { Faker::Lorem.characters 10 }
    body { Faker::Lorem.sentence }

    replacement { [true, false].sample }
  end
end
