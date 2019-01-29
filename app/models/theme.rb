class Theme < ApplicationRecord
  include HandleNames

  # relations
  has_many :collections, :dependent => :nullify

  # files
  mount_uploader :full_picture, FullCardPictureUploader
  mount_uploader :mini_picture, MiniCardPictureUploader

  # globalize
  translates :name
  globalize_accessors :locales => [:en, :ru], :attributes => [:name]

  # validation
  validates :real_id, :presence => true, :uniqueness => true
  validates :name, :presence => true

  # pagination
  paginates_per 16

  def self.default_scope
    order(:real_id => :asc)
  end

  def to_param
    real_id
  end
end
