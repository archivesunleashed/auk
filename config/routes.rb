# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users do
    resources :collections do
      post :download
      get :download_domains
      get :download_gexf
      get :download_fulltext
    end
  end

  root 'pages#show', page: 'home'
  get '/pages/:page' => 'pages#show'

  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
