require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  root to: 'serial_searches#index'
  resources :log_lines, only: [:create]
  resources :serial_searches, only: [:index, :show]
end
