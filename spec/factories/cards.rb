FactoryGirl.define do
  factory :card do
    real_id     { Faker::Lorem.words(3).join '-' }
    name        { Faker::Lorem.sentence 1 }
    intro       { Faker::Lorem.paragraph }
    description { Faker::Lorem.paragraph 6 }

    full_picture do
      Rack::Test::UploadedFile.new File.join(Rails.root, 'spec', 'support', 'cards', 'full_picture.jpg'), 'image/jpg'
    end
    mini_picture do
      Rack::Test::UploadedFile.new File.join(Rails.root, 'spec', 'support', 'cards', 'mini_picture.jpg'), 'image/jpg'
    end

    collection
  end
end
