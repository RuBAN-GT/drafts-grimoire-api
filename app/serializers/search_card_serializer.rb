class SearchCardSerializer < ApplicationSerializer
  attributes :id,
    :real_id,
    :name,
    :mini_picture_url,
    :collection_id,
    :collection_real_id,
    :collection_name,
    :theme_id,
    :theme_real_id,
    :theme_name

  def collection_real_id
    object.collection.real_id
  end

  def collection_name
    object.collection.name
  end

  def theme_id
    object.theme.id
  end

  def theme_real_id
    object.theme.real_id
  end

  def theme_name
    object.theme.name
  end
end
