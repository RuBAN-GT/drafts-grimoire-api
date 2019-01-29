class BungieClient::RailsClient < BungieClient::Client
  attr_reader :ttl
  attr_reader :prefix

  def initialize(options = {})
    options[:api_key] = Rails.application.secrets.x_api_key

    super options

    @ttl    = (options[:ttl].is_a?(Integer) && options[:ttl] > 60.seconds) ? options[:ttl] : 15.minutes
    @prefix = (options[:prefix].is_a? String) ? options[:prefix] : 'default'
  end

  def get(url, parameters = {}, headers = {})
    parameters = {} if parameters.nil?

    ttl    = (parameters[:ttl].is_a?(Integer) && parameters[:ttl] > 60.seconds) ? parameters[:ttl] : @ttl
    prefix = parameters[:prefix] || 'default'
    cached = parameters[:cached].nil? || !!parameters[:cached]

    parameters.delete :ttl
    parameters.delete :prefix
    parameters.delete :cached

    key   = cache_key url, parameters, prefix
    entry = nil

    if cached
      entry = Rails.cache.read key
      entry = Marshal.load entry unless entry.nil?
    end

    if entry.nil?
      entry = super url, parameters, headers

      Rails.cache.write key, Marshal.dump(entry), :expires_in => ttl || @ttl
    end

    entry
  end

  # Get cache key for `get` method
  def cache_key(uri, params = {}, extra = '')
    "#{@prefix}/#{extra}/#{uri}/#{Marshal.dump params}"
  end

  # Remove entry from cache
  def flush(key)
    Rails.cache.delete key
  end
end
