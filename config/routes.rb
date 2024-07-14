Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/auth'

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
