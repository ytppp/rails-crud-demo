Rails.application.routes.draw do
  root "articles#index"

  resources :articles do
    resources :comments
  end
  
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
