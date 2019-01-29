class Api::V1::ApplicationController < ApplicationController
  attr_reader :current_user

  before_action :handle_locale

  # Rescues
  rescue_from CanCan::AccessDenied do
    render :json => json_response(
      :success => false,
      :errors => current_user.nil? ? I18n.t('authorization.unauthorized') : I18n.t('authorization.forbidden')
    ),
    :status => (current_user.nil? ?	:unauthorized : :forbidden)
  end
  rescue_from ActionController::ParameterMissing do
    render :json => json_response(
      :success => false,
      :errors => I18n.t('errors.messages.wrong_parameters')
    ),
    :status => :forbidden
  end
  rescue_from ActionController::RoutingError, ActiveRecord::RecordNotFound do
    not_found
  end

  # Root page
  def home
    render :json => json_response(
      :data => {
        :grimoire => Grimoire::Application::VERSION,
        :api => 1
      }
    )
  end

  # 404 Page
  def not_found
    render :json => json_response(
      :success => false,
      :errors => I18n.t('errors.messages.not_found')
    ),
    :status => :not_found
  end

  protected

    # Handle client language and change server locale
    def handle_locale
      return if request.headers['Accept-Language'].nil?

      I18n.locale = case request.headers['Accept-Language'].downcase
        when 'ru' || 'russian'
          :ru
        when 'en' || 'english'
          :en
        else
          I18n.default_locale
      end
    end

    # Get token from header of request
    #
    # @return [String]
    def authorization_token
      @authorization_token ||= request.headers['Authorization']&.split(' ')&.last
    end

    # Get content from authorization token
    #
    # @return [Hashie::Mash]
    def authorization_token_content
      @authorization_token_content ||= JsonWebToken.decode authorization_token
    end

    # Check token for correction
    #
    # @return [Boolean]
    def authorization_token_valid?
      id = authorization_token_content.id

      return false if id.nil?

      user = User.find_by_id id

      !user.nil? && user.auth_token == authorization_token
    end

    # Require token authentication
    def authenticate_request!
      if authorization_token_valid?
        @current_user = User.find_by_id authorization_token_content.id

        @current_user.last_request_ip = request.remote_ip
        @current_user.touch :last_request_at
      else
        render :json => json_response(
          :success => false,
          :errors => I18n.t('authorization.wrong_token')
        ),
        :status => :unauthorized
      end
    end

    # Make token authentication if it possible
    def authenticate_request
      return unless authorization_token_valid?

      @current_user = User.find_by_id authorization_token_content.id

      @current_user.last_request_ip = request.remote_ip
      @current_user.touch :last_request_at

      @current_user
    end

    # Get json response for render
    #
    # @param [Hash] options
    # @option options [Boolean] success
    # @option options [Class] data
    # @option options [Array|String] errors
    # @return [Hash]
    def json_response(options = {})
      response = {}

      response[:success] = options.delete(:success)
      response[:success] = response[:success].nil? ? true : !!response[:success]

      response[:data]   = options.delete :data
      response[:errors] = options.delete :errors

      if response[:errors].is_a? String
        response[:errors] = [ response[:errors] ]
      elsif !response[:errors].is_a?(Array)
        response[:errors] = []
      end

      response.merge options
    end

    # Hash with pagination data for ActiveRecord object
    #
    # @param [Class] object
    # @return [Hash]
    def pagination_meta(object)
      {
        :count => object.length,
        :total_pages => object.total_pages,
        :current_page => object.current_page,
        :prev_page => object.prev_page,
        :next_page => object.next_page
      }
    end

    # Serialize a record
    #
    # @param [Class] record
    # @param [Class] serializer
    # @return [Hash]
    def record_serializing(record, serializer = nil)
      serializer = ActiveModel::Serializer.serializer_for record if serializer.nil?

      ActiveModelSerializers::SerializableResource.new(record, :serializer => serializer, :current_user => current_user).as_json.values.first
    end

    # Serialize collection
    #
    # @param [Class] record
    # @param [Class] serializer
    # @return [Array]
    def collection_serializing(collection, serializer = nil)
      serializer = "#{collection.class.to_s.split('::').first}Serializer".constantize if serializer.nil?

      ActiveModelSerializers::SerializableResource.new(collection, :each_serializer => serializer, :current_user => current_user).as_json.values.first
    end
end
