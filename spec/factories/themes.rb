FactoryGirl.define do
  factory :theme do
    I18n.locale = :en

    real_id { Faker::Lorem.words(2).join '-' }
    name    { Faker::Lorem.sentence 1 }

    full_picture do
      Rack::Test::UploadedFile.new File.join(Rails.root, 'spec', 'support', 'themes', 'full_picture.jpg'), 'image/jpg'
    end
    mini_picture do
      Rack::Test::UploadedFile.new File.join(Rails.root, 'spec', 'support', 'themes', 'mini_picture.jpg'), 'image/jpg'
    end

    factory :theme_with_collections do
      transient { collections_count 5 }

      after(:create) do |theme, evaluator|
        create_list :collection, evaluator.collections_count, :theme => theme
      end
    end

    trait :with_locale do
      I18n.locale = :ru

      name { Faker::Lorem.sentence 1 }
    end
  end
end
