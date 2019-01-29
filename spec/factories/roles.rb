FactoryGirl.define do
  factory :role do
    trait :admin do
      name :admin
      display_name 'Administrators'
    end

    trait :user do
      name :user
      display_name 'Users'
    end
  end
end
