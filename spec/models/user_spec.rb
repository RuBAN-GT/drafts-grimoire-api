require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'working with open cards' do
    let(:user) { FactoryGirl.create :user }
  
    before do
      stub_request(:get, /www\.bungie\.net\/Platform\/Destiny\/Vanguard\/Grimoire/).
        to_return( :body => File.open(Rails.root.join('spec', 'fixtures', 'vanguard_grimoire.json')) )
    end

    it 'returns open cards' do
      expect(user.cards_opened_real_ids.any?).to be_truthy
    end

    it 'checks card existing in user collection' do
      card_id = user.cards_opened_real_ids.sample

      expect(user.card_opened? card_id).to be_truthy
    end

    it 'returns card model for user' do
      theme = FactoryGirl.create :theme_with_collections

      card = FactoryGirl.attributes_for :card
      card['real_id'] = user.cards_opened_real_ids.sample
      card['collection'] = theme.collections.sample
      Card.create! card

      expect(user.cards_opened.any?).to be_truthy
    end
  end
end
