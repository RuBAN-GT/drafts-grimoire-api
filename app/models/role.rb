class Role < ApplicationRecord
  # Отношения
  has_and_belongs_to_many :users, :join_table => :users_roles

  # Валидация
  validates :name,
    :presence => true,
    :length => {
      :minimum => 2,
      :maximum => 16
    },
    :uniqueness => true

  validates :display_name, :length => { :maximum => 80 }
end
