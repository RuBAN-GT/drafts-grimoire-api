require 'rails_helper'

RSpec.describe BungieAuthenticator do
  describe '#get_tokens' do
    before do
      stub_request(:post, 'https://www.bungie.net/Platform/App/OAuth/Token/').
        with( :body => hash_including({ :code => 'wrong_code' }) ).
        to_return( :body => File.open(Rails.root.join('spec', 'fixtures', 'invalid_grant.json')) )

      stub_request(:post, 'https://www.bungie.net/Platform/App/OAuth/Token/').
        with( :body => hash_including({ :code => 'good_code' }) ).
        to_return( :body => File.open(Rails.root.join('spec', 'fixtures', 'oauth_token.json')) )
    end

    it 'returns json response with code error' do
      response = BungieAuthenticator.get_tokens 'wrong_code'

      expect(response).to eq(Hashie::Mash.new)
    end

    it 'return json response with tokens' do
      response = BungieAuthenticator.get_tokens 'good_code'

      expect(response.access_token).to be_a(String)
    end
  end

  describe '#get_info' do
    before do
      stub_request(:get, 'https://www.bungie.net/Platform/User/GetMembershipsForCurrentUser/').
        with( :headers => { 'Authorization' => 'Bearer wrong_token' } ).
        to_return( :body => File.open(Rails.root.join('spec', 'fixtures', 'invalid_grant.json')) )

      stub_request(:get, 'https://www.bungie.net/Platform/User/GetMembershipsForCurrentUser/').
        with( :headers => { 'Authorization' => 'Bearer good_token' } ).
        to_return( :body => File.open(Rails.root.join('spec', 'fixtures', 'oauth_info.json')) )
    end

    it 'returns json response with token error' do
      response = BungieAuthenticator.get_info 'wrong_token'

      expect(response).to eq(Hashie::Mash.new)
    end

    it 'returns response with user profile' do
      response = BungieAuthenticator.get_info 'good_token'

      expect(response.bungieNetUser.nil?).to be_falsey
    end
  end
end
