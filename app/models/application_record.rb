class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Префикс для ключа I18n моделей, атрибуты которых содержат ошибки
  def self.i18n_error_key(attribute = '')
    "activerecord.errors.models.#{self.name.downcase}.attributes.#{attribute}"
  end
end
