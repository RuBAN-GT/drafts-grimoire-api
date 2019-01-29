require 'rails_helper'

RSpec.describe "Api::V1::ThemesController", type: :request do
  let(:theme) { FactoryGirl.create :theme, :with_locale }

  describe "GET /api/v1/themes/*" do
    it "returns http success for theme by real_id" do
      get "#{api_v1_themes_path}/#{theme.real_id}"

      expect(response).to have_http_status(:ok)
    end
    
    it "returns theme with translates for request with header" do
      get "#{api_v1_themes_path}/#{theme.real_id}", :headers => { 
        'Accept-Language': 'en' 
      }
      english = JSON.parse(response.body)['data']

      get "#{api_v1_themes_path}/#{theme.real_id}", :headers => {
        'Accept-Language': 'ru'
      }
      russian = JSON.parse(response.body)['data']

      expect(english['name'] != russian['name']).to be_truthy
    end
  end
end
