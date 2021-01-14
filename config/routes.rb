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
      get :download_textfilter
      get :domains_chart
      get :crawl_dates_chart
    end
  end

  get 'dashboards' => 'dashboards#index'
  get 'dashboards/jobs' => 'dashboards#jobs'
  get 'dashboards/graphs' => 'dashboards#graphs'
  get 'dashboards/stats' => 'dashboards#stats'
  get 'dashboards/users_chart' => 'dashboards#users_chart'
  get 'dashboards/users_pie_chart' => 'dashboards#users_pie_chart'
  get 'dashboards/jobs_chart' => 'dashboards#jobs_chart'
  get 'dashboards/spark_throughput_chart' =>
    'dashboards#spark_throughput_chart'
  get 'dashboards/spark_times_chart' =>
    'dashboards#spark_times_chart'
  get 'dashboards/download_throughput_chart' =>
    'dashboards#download_throughput_chart'
  get 'dashboards/download_times_chart' =>
    'dashboards#download_times_chart'
  get 'dashboards/graphpass_throughput_chart' =>
    'dashboards#graphpass_throughput_chart'
  get 'dashboards/graphpass_times_chart' =>
    'dashboards#graphpass_times_chart'
  get 'dashboards/textfilter_throughput_chart' =>
    'dashboards#textfilter_throughput_chart'
  get 'dashboards/textfilter_times_chart' =>
    'dashboards#textfilter_times_chart'
  get 'dashboards/seed_times_chart' =>
    'dashboards#seed_times_chart'
  get 'dashboards/cleanup_throughput_chart' =>
    'dashboards#cleanup_throughput_chart'
  get 'dashboards/cleanup_times_chart' =>
    'dashboards#cleanup_times_chart'

  root 'pages#show', page: 'home'
  get '/pages/:page' => 'pages#show'
  get 'about' => 'pages#about'
  get 'archiveit' => 'pages#archiveit'
  get 'documentation' => 'pages#documentation'
  get 'faq' => 'pages#faq'
  get 'privacypolicy' => 'pages#privacypolicy'
  get 'derivatives/basic-gephi' => 'pages#basic-gephi'
  get 'derivatives/gephi' => 'pages#gephi'
  get 'derivatives/domains' => 'pages#domains'
  get 'derivatives/text-antconc' => 'pages#text-antconc'
  get 'derivatives/text-sentiment' => 'pages#text-sentiment'
  get 'derivatives' => 'pages#derivatives'
  get 'derivatives/text-filtering' => 'pages#text-filtering'
  get 'derivatives/notebooks' => 'pages#notebooks'

  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unacceptable'
  get '/500', to: 'errors#internal_error'
end
