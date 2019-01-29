require 'rails_helper'

RSpec.describe Api::V1::CardsController, type: :controller do
  let(:theme) { FactoryGirl.create :theme }
  let(:collection) { FactoryGirl.create :collection, :theme => theme }
  let(:cards) { FactoryGirl.create_list :card, 30, :collection => collection }
  let(:card) { FactoryGirl.create :card, :collection => collection }

  describe 'GET #search' do
    it 'returns card by name in query' do
      get :search, :params => { :q => cards.first.name }

      result = JSON.parse(response.body)

      expect(result['data'].any?).to be_truthy
    end

    it 'returns card by name in uppercase' do 
      get :search, :params => { :q => cards.first.name.upcase }
      
      result = JSON.parse(response.body)

      expect(result['data'].any?).to be_truthy
    end

    it 'returns empty data for bad query' do
      get :search, :params => { :q => 'wahahaha' }

      expect(JSON.parse(response.body)['data'].any?).to be_falsy
    end

    it 'returns error for empty query' do
      get :search, :params => { :q => '' }

      expect(JSON.parse(response.body)['success']).to be_falsy
    end

    it 'returns error for bad request' do
      get :search

      expect(JSON.parse(response.body)['success']).to be_falsy
    end
  end

  describe 'working with reading' do
    let(:user) { FactoryGirl.create :user }

    it 'return successs for POST #read' do
      request.headers.merge! 'Authorization' => "Bearer #{user.auth_token}"

      post :read, :params => { 
        :card_real_id => card.real_id,
        :theme_real_id => theme.real_id,
        :collection_real_id => collection.real_id
      }

      expect(user.reload.cards).not_to be_empty
    end

    it 'returns success for DELETE :unread' do
      request.headers.merge! 'Authorization' => "Bearer #{user.auth_token}"

      user.cards << card

      delete :unread, :params => { 
        :theme_real_id => theme.real_id,
        :collection_real_id => collection.real_id,
        :card_real_id => card.real_id
      }

      expect(user.reload.cards).to be_empty
    end
  end
end
