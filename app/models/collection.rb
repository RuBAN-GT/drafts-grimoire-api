class Collection < ApplicationRecord
  include HandleNames
  
  # relations
  belongs_to :theme
  has_many :cards, :dependent => :nullify

  # files
  mount_uploader :full_picture, FullCardPictureUploader
  mount_uploader :mini_picture, MiniCardPictureUploader

  # globalize
  translates :name
  globalize_accessors :locales => [:en, :ru], :attributes => [:name]

  # validation
  validates :real_id, :presence => true, :uniqueness => true
  validates :name, :presence => true
  validates :theme, :presence => true

  # pagination
  paginates_per 100

  def to_param
    real_id
  end
end
