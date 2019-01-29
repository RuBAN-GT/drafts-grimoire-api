Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/super', as: 'rails_admin'

  root 'application#home'

  namespace :api, :defaults => {:format => :json} do
    namespace :v1, :constraints => ApiVersion.new(1) do
      root 'application#home'

      get 'events', :to => 'events#tweets'

      post 'auth/bungie', :to => 'authentication#bungie'
      get  'auth/validate_token', :to => 'authentication#validate_token'

      resources :users, :only => %w(show)

      resources :tooltips, :only => %w(index show create update destroy)

      get 'search', :to => 'cards#search'
      resources :themes, :param => :real_id, :only => %w(index show update destroy) do
        resources :collections, :param => :real_id, :only => %w(index show update destroy) do
          resources :cards, :param => :real_id, :only => %w(index show update destroy) do
            post :read
            delete :unread
          end
        end
      end

      match '*path' => 'application#not_found', :via => :all unless Rails.env.development?
    end
  end

  match '*path' => 'application#not_found', :via => :all unless Rails.env.development?
end
