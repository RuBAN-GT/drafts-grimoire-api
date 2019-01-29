require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :controller do
  describe 'GET #show' do
    before do
      stub_request(:get, /twitter.com/)
        .to_return(:body => File.open(Rails.root.join('spec', 'fixtures', 'twitter_user_timeline.json')))
    end

    it 'returns json with events' do
      get :tweets

      expect(JSON.parse(response.body)['data'].any?).to be_truthy
    end
  end
end
