FactoryGirl.define do
  factory :collection do
    real_id { Faker::Lorem.words(2).join '-' }
    name    { Faker::Lorem.sentence 1 }

    full_picture do
      Rack::Test::UploadedFile.new File.join(Rails.root, 'spec', 'support', 'collections', 'full_picture.jpg'), 'image/jpg'
    end
    mini_picture do
      Rack::Test::UploadedFile.new File.join(Rails.root, 'spec', 'support', 'collections', 'mini_picture.jpg'), 'image/jpg'
    end

    theme

    factory :collection_with_cards do
      transient { cards_count 5 }

      after(:create) do |collection, evaluator|
        create_list :card, evaluator.cards_count, :collection => collection
      end
    end
  end
end
