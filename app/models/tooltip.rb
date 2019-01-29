class Tooltip < ApplicationRecord
  # validation
  validates :slug,
    :presence => true,
    :uniqueness => {
      :scope => :replacement
    },
    :length => {
      :maximum => 250
    }
  validates :body, :presence => true, :length => {
    :maximum => 250
  }

  # pagination
  paginates_per 1000

  # hooks
  before_save do
    self.slug = self.slug.gsub(', ', ',')
  end

  # Find similar tooltips for current object
  def similars
    Tooltip.where(:body => [
      body, 
      "The #{body}"
    ]).where.not(:id => id)
  end
  
  def self.similars
    result = Tooltip.all.map do |tooltip|
      {
        :tooltip => tooltip,
        :similars => tooltip.similars
      }
    end
    
    result.select do |g| 
      g[:similars].length > 0
    end
  end
end
