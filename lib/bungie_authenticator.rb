module BungieAuthenticator
  class << self
    # Get tokens from oauth2 service with code
    #
    # @param [String] code
    # @return [Hashie::Mash]
    def get_tokens(code)
      # make client for access tokens
      client = BungieClient::Client.new :api_key => Rails.application.secrets.x_api_key

      # form Authorization header
      auth = Base64.encode64 "#{Rails.application.secrets.oauth['client_id']}:#{Rails.application.secrets.oauth['client_secret']}"

      # get access tokens
      response = client.post(
        'App/OAuth/Token/',
        {
          :grant_type => :authorization_code,
          :code => code
        },
        {
          'Content-Type' => 'application/x-www-form-urlencoded',
          'Authorization' => "Basic #{auth.gsub "\n", ''}"
        }
      )

      response.key?(:error) ? Hashie::Mash.new : response
    end

    # Get information for user by access token
    #
    # @param [String] token
    # @return [Hashie::Mash]
    def get_info(token)
      client = BungieClient::Wrapper.new(
        :api_key => Rails.application.secrets.x_api_key,
        :token => token
      )

      response = client.get_membership_data_for_current_user

      response.ErrorCode == 1 ? response.Response : Hashie::Mash.new
    end
  end
end
