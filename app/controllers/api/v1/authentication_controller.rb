class Api::V1::AuthenticationController < Api::V1::ApplicationController
  # Validate user authorization token
  def validate_token
    render :json => json_response(
      :success => authorization_token_valid?,
      :errors => authorization_token_valid? ? nil : I18n.t('authorization.wrong_token')
    ),
    :status => authorization_token_valid? ? :ok : :bad_request
  end

  # Register or authenticate user by bungie code
  def bungie
    code = params.require(:code)

    # Get tokens by code
    tokens = BungieAuthenticator.get_tokens code
    if tokens.any?
      # Try to get any information from bungie by access token
      auth  = BungieAuthenticator.get_info tokens.access_token
      @user = User.from_oauth auth

      if @user.persisted?
        render :json => json_response(
          :data => {
            :auth_token => @user.auth_token,
            :user => record_serializing(@user)
          }
        ),
        :status => :ok
      else
        failure
      end
    else
      failure
    end
  end

  def failure
    render :json => json_response(
      :success => false,
      :errors => I18n.t('authorization.wrong_code')
    ),
    :status => :bad_request
  end
end
