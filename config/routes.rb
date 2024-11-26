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

  resource :cart, only: [:show] do
    post :add_to_cart, on: :collection
    patch :update_item, on: :collection
    delete :remove_item, on: :collection
    delete :clear_cart, on: :collection
  end

  resources :orders, only: [:new, :create, :show]

  post '/checkout/create', to: 'checkout#create', as: :create_checkout_session


  root 'home#index'
end
