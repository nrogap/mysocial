Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/auth'

  resources :posts

  get "up" => "rails/health#show", as: :rails_health_check

  root "posts#index"
end
