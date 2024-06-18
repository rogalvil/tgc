# frozen_string_literal: true

# Routes for the API
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index customers] do
        collection do
          get 'customers'
        end
      end
    end
  end

  # Devise routes for user authentication
  devise_for :users, defaults: { format: :json },
                     path: '',
                     path_names: {
                       sign_in: 'api/v1/login',
                       sign_out: 'api/v1/logout',
                       registration: 'api/v1/signup'
                     },
                     controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations'
                     }

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ('/')
  # root 'posts#index'
end
