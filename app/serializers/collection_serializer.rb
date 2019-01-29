class CollectionSerializer < ApplicationSerializer
  attributes :id,
    :real_id,
    :name,
    :full_picture_url,
    :mini_picture_url,
    :theme_id,
    :theme_real_id,
    :created_at,
    :updated_at

  def theme_real_id
    object.theme.real_id
  end
end
