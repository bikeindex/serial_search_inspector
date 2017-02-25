require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :accounts, only: [:index, :show]
  get 'refresh_bike_index', to: 'accounts#refresh_bike_index_credentials'

  authenticate :user, lambda { |u| u.superuser? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: 'serial_searches#index'

  resources :log_lines, only: [:create]
  resources :ip_addresses, only: [:index, :show, :edit, :update]
  resources :serial_searches, only: [:index, :show]
  resources :graphs, only: [:index] do
    collection do
      get 'source_type'
      get 'uniquely_created_entries'
    end
  end
end
