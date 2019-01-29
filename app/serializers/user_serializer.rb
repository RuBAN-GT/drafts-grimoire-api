class UserSerializer < ApplicationSerializer
  has_many :roles

  attributes :id,
    :roles,
    :opened,
    :readed,
    :created_at,
    :updated_at,
    :last_request_at,
    :last_request_ip,
    :membership_id,
    :display_name,
    :unique_name,
    :destiny_membership_id,
    :membership_type

  def opened
    object.cards_opened_real_ids
  end

  def readed
    object.cards.ids
  end
end
