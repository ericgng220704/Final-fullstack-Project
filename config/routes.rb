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
  resource :profile, only: [:show, :edit, :update], controller: 'users'

  resources :user_orders, only: [] do
    patch :cancel, on: :member
    patch :confirm, on: :member
  end


  resource :cart, only: [:show] do
    post :add_to_cart, on: :collection
    patch :update_item, on: :collection
    delete :remove_item, on: :collection
    delete :clear_cart, on: :collection
  end

  resources :orders, only: [:index, :show]

  post '/checkout/create', to: 'checkout#create', as: :create_checkout_session
  get '/checkout/success', to: 'checkout#success', as: :checkout_success
  get '/checkout/cancel', to: 'checkout#cancel', as: :checkout_cancel


  root 'home#index'
end
