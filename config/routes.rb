# require 'sidekiq/web'

Rails.application.routes.draw do
  # mount Sidekiq::Web => '/sidekiq'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'serial_searches#index'

  resources :serial_searches, only: [:index, :show]
  resources :log_lines, only: [:create]
end
