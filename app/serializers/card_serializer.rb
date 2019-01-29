class CardSerializer < ApplicationSerializer
  attributes :id,
    :real_id,
    :name,
    :intro,
    :description,
    :full_picture_url,
    :mini_picture_url,
    :collection_id,
    :collection_real_id,
    :theme_id,
    :theme_real_id,
    :glossary,
    :replacement,
    :created_at,
    :updated_at

  def collection_real_id
    object.collection.real_id
  end

  def theme_id
    object.theme.id
  end

  def theme_real_id
    object.theme.real_id
  end
end
