Larks::Application.routes.draw do
  devise_for :startups
  get "applicants/index"
  resources :facebook_pull

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :applicants
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  #, :skip => [:sessions] do
    #delete 'users/sign_out' => 'devise/sessions#destroy', :as => 'destroy_user_session'
  #end

  #pages controller
  authenticated do
    root to: 'pages#index'
  end

  resources :users
  root to: 'pages#index'
  match '/features' => 'pages#features', as: :features, via: :get
  match '/pricing' => 'pages#pricing', as: :pricing, via: :get
  match '/about' => 'pages#about', as: :about, via: :get
  match '/thank_you' => 'pages#thank_you', as: :thank_you, via: :get
  match '/filter' => 'pages#filter', as: :filter, via: :post
  match '/invitation' => 'users#invitation', as: :invitation, via: :post
  resources :users, only: ['show', 'edit', 'update']
  match '/invites' => 'users#invites', as: :invites, via: :get

  #users controller
  resources :users, only: ['show', 'edit', 'update']
  match '/profile' => 'users#show_profile', as: :profile, via: :get
  match '/edit_profile' => 'users#edit_profile', as: :edit_profile, via: :get
  match '/update_profile' => 'users#update_profile', as: :update_profile, via: :put
  match '/users/:id/show_applicant' => 'users#show_applicant', as: :show_applicant, via: :get

  #analytics controller
  resources :analytics, only: ['index']
end
