require 'rails_helper'

RSpec.describe Api::V1::TooltipsController, type: :controller do
  let(:admin) { FactoryGirl.create :user, :admin }
  let(:tooltip) { FactoryGirl.create :tooltip }

  describe 'Default actions for controller (create, update, destroy)' do
    it 'returns http success for #create of tooltip' do
      request.headers.merge! 'Authorization' => "Bearer #{admin.auth_token}"

      tooltip_attrs = FactoryGirl.attributes_for :tooltip
      post :create, :params => { :tooltip => tooltip_attrs }

      expect(response).to have_http_status(:success)
    end

    it 'returns http success for #update of tooltip' do
      request.headers.merge! 'Authorization' => "Bearer #{admin.auth_token}"

      tooltip_attrs = FactoryGirl.attributes_for :tooltip
      put :update, :params => { :id => tooltip.id, :tooltip => tooltip_attrs }

      expect(response).to have_http_status(:success)
    end

    it 'returns http success for #destroy of tooltip' do
      request.headers.merge! 'Authorization' => "Bearer #{admin.auth_token}"

      delete :destroy, :params => { :id => tooltip.id }

      expect(response).to have_http_status(:success)
    end
  end
end
