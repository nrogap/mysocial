Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "api/auth"

  namespace :api do
    resources :posts do
      collection do
        get "users/:user_id" => "posts#index_by_user"
      end
    end
  end

  resources :posts

  get "up" => "rails/health#show", as: :rails_health_check

  root "posts#index"
end
