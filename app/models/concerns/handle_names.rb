module HandleNames
  extend ActiveSupport::Concern

  included do
    before_save :handle_name
  end

  protected

    def handle_name
      self.name = self.name.capitalize
    end
end
