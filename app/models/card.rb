class Card < ApplicationRecord
  include HandleNames
  
  # relations
  belongs_to :collection
  has_and_belongs_to_many :users, :join_table => :user_cards

  # files
  mount_uploader :full_picture, FullCardPictureUploader
  mount_uploader :mini_picture, MiniCardPictureUploader

  # globalize
  translates :name, :intro, :description
  globalize_accessors :locales => [:en, :ru], :attributes => [:name, :intro, :description]

  # pagination
  paginates_per 100

  # validation
  validates :real_id, :presence => true, :uniqueness => true
  validates :name, :presence => true
  validates :collection, :presence => true

  # hooks
  before_save :remove_empty

  def theme
    collection.theme
  end

  def to_param
    real_id
  end

  protected

    def remove_empty
      empty = ['<p></p>', '<p>&nbsp;</p>', ' ', '&nbsp;']
      
      self.intro = '' if empty.include? self.intro
      self.description = '' if empty.include? self.description
    end
end
