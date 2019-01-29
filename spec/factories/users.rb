FactoryGirl.define do
  factory :user do
    membership_id { Faker::Number.number 8 }
    display_name { Faker::Name.name }
    unique_name { Faker::Internet.user_name }
    destiny_membership_id { Faker::Number.number 19 }
    membership_type { %w(1 2).sample }

    trait :admin do
      roles do
        role = Role.find_by_name 'admin'

        role.nil? ? [ create(:role, :admin) ] : [ role ]
      end
    end
  end
end
