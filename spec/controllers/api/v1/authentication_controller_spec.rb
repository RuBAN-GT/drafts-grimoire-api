require 'rails_helper'

RSpec.describe Api::V1::AuthenticationController, type: :controller do
  let(:admin) { FactoryGirl.create :user, :admin }

  describe 'GET #validate_token' do
    it 'returns json with positive status of token' do
      request.headers.merge! 'Authorization' => "Bearer #{admin.auth_token}"

      get :validate_token

      expect(JSON.parse(response.body)['success']).to be_truthy
    end

    it 'returns json with negative status of token' do
      request.headers.merge! 'Authorization' => 'Bearer bad_token'

      get :validate_token

      expect(JSON.parse(response.body)['success']).to be_falsey
    end
    
    it 'returns json with negative status for old token' do
      request.headers.merge! 'Authorization' => "Bearer #{admin.auth_token}"

      admin.display_name = 'New name'

      admin.save

      get :validate_token

      expect(JSON.parse(response.body)['success']).to be_falsey
    end

    it 'returns json with negative status for request without token' do
      get :validate_token

      expect(JSON.parse(response.body)['success']).to be_falsey
    end
  end

  describe 'POST #bungie' do
    before do
      stub_request(:post, 'https://www.bungie.net/Platform/App/OAuth/Token/').
        with( :body => hash_including({ :code => 'wrong_code' }) ).
        to_return( :body => File.open(Rails.root.join('spec', 'fixtures', 'invalid_grant.json')) )

      stub_request(:post, 'https://www.bungie.net/Platform/App/OAuth/Token/').
        with( :body => hash_including({ :code => 'good_code' }) ).
        to_return( :body => File.open(Rails.root.join('spec', 'fixtures', 'oauth_token.json')) )

      stub_request(:get, 'https://www.bungie.net/Platform/User/GetMembershipsForCurrentUser/').
        with( :headers => { 'Authorization' => 'Bearer XXXX' } ).
        to_return( :body => File.open(Rails.root.join('spec', 'fixtures', 'oauth_info.json')) )
      
      stub_request(:get, /www\.bungie\.net\/Platform\/Destiny\/Vanguard\/Grimoire/).
        to_return( :body => File.open(Rails.root.join('spec', 'fixtures', 'vanguard_grimoire.json')) )
    end

    it 'returns forbidden for empty code' do
      post :bungie, :params => {}

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns #failure with 400 for wrong code' do
      post :bungie, :params => { :code => 'wrong_code' }

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns user info for good code' do
      post :bungie, :params => { :code => 'good_code' }

      expect(response).to have_http_status(:ok)
    end
  end
end
