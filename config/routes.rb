Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: "merchant_items"
      end

      resources :items, only: [:index, :show, :create, :destroy, :update]
    end
  end
end
