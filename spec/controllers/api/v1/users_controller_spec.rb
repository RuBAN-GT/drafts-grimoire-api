require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'GET #show' do
    before { stub_request(:get, /bungie.net/).to_return(:body => '{}') }

    it 'returns json with user for by itself' do
      user = FactoryGirl.create :user
      request.headers.merge! 'Authorization' => "Bearer #{user.auth_token}"

      get :show, :params => { :id => user.id }

      expect(response).to have_http_status(:success)
    end

    it 'returns forbidden' do
      FactoryGirl.create_list :user, 3

      request.headers.merge! 'Authorization' => "Bearer #{User.last.auth_token}"

      get :show, :params => { :id => User.first.id }

      expect(response).to have_http_status(:forbidden)
    end
  end
end
