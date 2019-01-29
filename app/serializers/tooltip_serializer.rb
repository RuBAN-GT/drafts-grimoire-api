class TooltipSerializer < ApplicationSerializer
  attributes :id,
    :slug,
    :body,
    :replacement,
    :created_at,
    :updated_at
end
