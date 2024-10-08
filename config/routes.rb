# frozen_string_literal: true

# Routes for the API
Rails.application.routes.draw do
  apipie
  namespace :api do
    namespace :v1 do
      resources :users
      resources :products do
        member do
          patch :stock, to: 'products#update_stock'
          patch :status, to: 'products#update_status'
        end
      end
      resources :orders do
        member do
          patch :status, to: 'orders#update_status'
        end
        resources :order_items, path: :items
      end
    end
  end

  # Devise routes for user authentication
  devise_for :users, defaults: { format: :json }, path: '',
                     path_names: {
                       sign_in: 'api/v1/login',
                       sign_out: 'api/v1/logout',
                       registration: 'api/v1/signup',
                       password: 'api/v1/password'
                     },
                     controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations',
                       passwords: 'users/passwords'
                     },
                     skip: %i[sessions registrations passwords]

  devise_scope :user do
    post 'api/v1/login', to: 'users/sessions#create', as: :user_session
    delete 'api/v1/logout', to: 'users/sessions#destroy', as: :destroy_user_session

    post 'api/v1/signup', to: 'users/registrations#create', as: :user_registration

    post 'api/v1/password', to: 'users/passwords#create'
    patch 'api/v1/password', to: 'users/passwords#update'
    put 'api/v1/password', to: 'users/passwords#update'
  end

  # Catch all unmatched routes
  match '*unmatched', to: 'application#route_not_found', via: :all

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ('/')
  # root 'posts#index'
end
