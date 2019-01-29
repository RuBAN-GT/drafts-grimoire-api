require 'rails_helper'

RSpec.describe JsonWebToken do
  it 'returns correct string with token' do
    token = JsonWebToken.encode :user_id => 1

    expect(token).to be_a(String)
  end

  it 'returns filled hash for correct token' do
    token = JsonWebToken.encode :user_id => 1
    hash  = JsonWebToken.decode token

    expect(hash.user_id).to eq(1)
  end

  it 'returns empty hash for invalid token' do
    expect(JsonWebToken.decode('hello')).to eq(Hashie::Mash.new)
  end
end
