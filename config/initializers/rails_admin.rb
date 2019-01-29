RailsAdmin.config do |config|
  config.authenticate_with do
    authenticate_or_request_with_http_basic('Login required') do |username, password|
      if password == Rails.application.secrets.rails_admin
        user = User.find_by :display_name => username

        user unless user.nil? || !user.role?(:admin)
      end
    end
  end

  config.show_gravatar = true

  config.actions do
    dashboard
    index
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
  end
end
