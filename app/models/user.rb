class User < ApplicationRecord
  # Relations
  has_and_belongs_to_many :roles, :join_table => :users_roles
  has_and_belongs_to_many :cards, :join_table => :user_cards

  # Validation
  validates :membership_id, :presence => true, :uniqueness => true
  validates :unique_name, :presence => true
  validates :display_name, :presence => true
  validates :membership_type, :presence => true
  validates :destiny_membership_id, :presence => true, :uniqueness => true
  
  # Check role existence for user
  #
  # @param [String|Symbol] role
  # @return [Boolean]
  def role?(role)
    !roles.find_by_name(role.to_s).nil?
  end

  # Generate user for auth settings
  def self.from_oauth(auth)
    where(:membership_id => auth.bungieNetUser&.membershipId).first_or_create do |user|
      user.display_name = auth.bungieNetUser&.displayName
      user.unique_name  = auth.bungieNetUser&.uniqueName

      guardian = auth.destinyMemberships.last
      unless guardian.nil?
        user.destiny_membership_id = guardian.membershipId
        user.membership_type       = guardian.membershipType
      end
    end
  end

  # Generate authentication token
  #
  # @return [String]
  def auth_token
    @auth_token ||= JsonWebToken.encode(
      :id => id,
      :display_name => display_name,
      :unique_name => unique_name,
      :roles => roles.map { |item| item.name }
    )
  end

  # Get guardian client for requests
  #
  # @return [BungieClient::Wrapper]
  def guardian_client
    return nil unless persisted?

    @guardian_client ||= BungieClient::Wrapper.new :client => BungieClient::RailsClient.new(
      :prefix => "client.#{membership_id}",
      :ttl => 1.month
    )
  end

  # Get real ids for guardian opened cards for one day
  #
  # @return [Array]
  def cards_opened_real_ids
    return [] if guardian_client.nil?
    return @cards_ids unless @cards_ids.nil?

    @cards_ids = guardian_client.get_grimoire_by_membership(
      {
        :membershipType => membership_type,
        :destinyMembershipId => destiny_membership_id
      }, 
      { 
        :ttl => 1.day 
      }
    )&.Response&.data&.cardCollection || []

    @cards_ids = @cards_ids.map { |card| card.cardId.to_s }
  end

  # Get open cards from database
  #
  # @return [Array]
  def cards_opened
    Card.where(:real_id => cards_opened_real_ids)
  end

  # Check if current card is opened by user
  #
  # @param [String] real_id of the card
  # @return [Boolean]
  def card_opened?(real_id)
    cards_opened_real_ids.include? real_id
  end
end
