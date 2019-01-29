class ThemeSerializer < ApplicationSerializer
  attributes :id,
    :real_id,
    :name,
    :full_picture_url,
    :mini_picture_url,
    :created_at,
    :updated_at
end
