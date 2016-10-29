require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }
  mount Sidekiq::Web => '/sidekiq'
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
