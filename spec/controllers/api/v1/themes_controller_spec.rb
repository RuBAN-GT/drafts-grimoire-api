require 'rails_helper'

RSpec.describe Api::V1::ThemesController, type: :controller do
  let(:user)  { FactoryGirl.create :user }
  let(:admin) { FactoryGirl.create :user, :admin }
  let(:theme) { FactoryGirl.create :theme }

  describe 'PUT update' do
    it 'returns http success for authorized user' do
      request.headers.merge! 'Authorization' => "Bearer #{admin.auth_token}"

      theme_attributes = FactoryGirl.attributes_for :theme
      put :update, :params => { :real_id => theme.real_id, :theme => theme_attributes }

      expect(response).to have_http_status(:success)
    end

    it 'returns http unauthorized for guest' do
      theme_attributes = FactoryGirl.attributes_for :theme
      put :update, :params => { :real_id => theme.real_id, :theme => theme_attributes }

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns http forbidden for authorized user' do
      request.headers.merge! 'Authorization' => "Bearer #{user.auth_token}"

      theme_attributes = FactoryGirl.attributes_for :theme
      put :update, :params => { :real_id => theme.real_id, :theme => theme_attributes }

      expect(response).to have_http_status(:forbidden)
    end
  end
end
