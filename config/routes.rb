# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users
  root 'pages#show', page: 'home'
  get '/pages/:page' => 'pages#show'

  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
