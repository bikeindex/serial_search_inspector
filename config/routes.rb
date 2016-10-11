require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  root to: 'serial_searches#index'

  resources :graphs, only: [:index] do
    collection do
      get 'source_type'
      get 'unique_created'
      get 'unique_created_day'
      get 'unique_created_week'
      get 'unique_created_month'
      get 'unique_created_year'
    end
  end
  resources :log_lines, only: [:create]
  resources :ip_addresses, only: [:index, :show]
  resources :serial_searches, only: [:index, :show]
end
