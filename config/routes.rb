# frozen_string_literal: true

Rails.application.routes.draw do
  mount Delayed::Web::Engine, at: '/jobs'
  Delayed::Web::Engine.middleware.use Rack::Auth::Basic do |username, password|
    username == ENV['DJW_USERNAME'] && password == ENV['DJW_PASSWORD']
  end
  resources :users do
    resources :collections do
      post :download
      get :download_domains
      get :download_gexf
      get :download_graphml
      get :download_fulltext
    end
  end

  resources :dashboards

  root 'pages#show', page: 'home'
  get '/pages/:page' => 'pages#show'
  get 'about' => 'pages#about'
  get 'documentation' => 'pages#documentation'

  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unacceptable'
  get '/500', to: 'errors#internal_error'
end
