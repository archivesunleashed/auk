Rails.application.routes.draw do
  get 'users/index'

  root to: 'users#index'
  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
