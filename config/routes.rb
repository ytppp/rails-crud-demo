Rails.application.routes.draw do
  root "articles#index"

  resources :articles do
    resources :comments
  end

  resources :quotes
  
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :create, :update, :destroy]
      resources :tokens, only: [:create]
    end
  end
end
