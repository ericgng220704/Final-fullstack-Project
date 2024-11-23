Rails.application.routes.draw do
  get "pages/show"
  get "home/index"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  get '/contact', to: 'pages#show', defaults: { id: 'Contact' }, as: :contact
  post '/contact', to: 'pages#contact', as: :submit_contact
  get '/about', to: 'pages#show', defaults: { id: 'About' }, as: :about

  resources :products, only: [:index, :show]
  root 'home#index'
end
