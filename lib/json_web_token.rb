module JsonWebToken
  class << self
    # Encode data to JWT
    #
    # @param [Hash] payload
    # @return [String]
    def encode(payload)
      JWT.encode payload, Rails.application.secrets.secret_key_base rescue ''
    end

    # Decode JWT to hash
    #
    # @param [String] token
    # @return [Hashie::Mash]
    def decode(token)
      Hashie::Mash.new JWT.decode(token, Rails.application.secrets.secret_key_base).first
    rescue
      Hashie::Mash.new
    end
  end
end
