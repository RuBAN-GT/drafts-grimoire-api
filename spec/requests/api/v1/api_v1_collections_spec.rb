require 'rails_helper'

RSpec.describe "Api::V1::CollectionsController", type: :request do
  let(:theme) { FactoryGirl.create :theme }
  let(:collection) { FactoryGirl.create :collection, :theme => theme }

  describe "GET /api/v1/themes/:theme_real_id/collections/*" do
    it "returns http success for collection by real_id" do
      get "#{api_v1_themes_path}/#{theme.real_id}/collections/#{collection.real_id}"

      expect(response).to have_http_status(:ok)
    end

    it 'returns not_found for collection with wrong id' do
      get "#{api_v1_themes_path}/#{theme.real_id}/collections/some_wrong_code"

      expect(response).to have_http_status(:not_found)
    end
  end
end
