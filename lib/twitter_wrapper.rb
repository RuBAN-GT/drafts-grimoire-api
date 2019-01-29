class TwitterWrapper
  attr_reader :username

  # Initialize twitter client with secret parameters
  #
  # @param [Hash] options
  def initialize(options = {})
    @consumer_key = options[:consumer_key] || Rails.application.secrets.twitter['consumer_key']
    @consumer_secret = options[:consumer_secret] || Rails.application.secrets.twitter['consumer_secret']
    @access_token = options[:access_token] || Rails.application.secrets.twitter['access_token']
    @access_token_secret = options[:access_token_secret] || Rails.application.secrets.twitter['access_token_secret']
    @username = options[:username] || Rails.application.secrets.twitter['username']
  end

  # Twitter client for requests
  #
  # @return [Twitter::REST::Client]
  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = @consumer_key
      config.consumer_secret     = @consumer_secret
      config.access_token        = @access_token
      config.access_token_secret = @access_token_secret
    end
  end

  # Get tweet messages
  #
  # @param [Integer] count
  # @return [Array]
  def tweets(count = 10)
    cache = Rails.cache.read "tweets.#{username}.#{count}"
    return cache unless cache.nil? || !cache.any?

    tweets = client.user_timeline(
      @username,
      :count => count,
      :exclude_replies => true
    ) rescue []

    tweets.map! do |tweet|
      Hashie::Mash.new(
        :id => tweet.id,
        :created_at => tweet.created_at.strftime('%d.%m.%y'),
        :text => tweet.full_text,
        :url => tweet.url.to_s
      )
    end

    Rails.cache.write "tweets.#{username}.#{count}", tweets, :expires_in => 1.hour if tweets.any?

    tweets
  end
end
