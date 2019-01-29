class ApplicationController < ActionController::API
  include CanCan::ControllerAdditions

  # Root page
  def home
    render :json => {
      :grimoire => Grimoire::Application::VERSION
    }
  end

  # Generate 404 error
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
