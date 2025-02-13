Rails.application.routes.draw do
  devise_for :devise_users
  root to: "pages#home"

  resources :articles do
    resources :comments
  end

  resources :quotes

  namespace :api, default: { format: :json } do
    namespace :v1 do
      resources :users, only: [:index, :show, :create, :update, :destroy]
      resources :shops, only: [:index, :show, :create, :update, :destroy]
      resources :products, only: %i[index show create update destroy]
      resources :sessions, only: [:create]
    end
  end
end
