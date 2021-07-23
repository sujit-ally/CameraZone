Rails.application.routes.draw do

  resources :stores
  devise_for :users

  
  get 'gallery/index'
  get 'gallery/checkout'
  post 'gallery/checkout'
  get "gallery/search"
  post "gallery/search"


  get 'gallery/purchase_complete'
  resources :orders
  resources :line_items
  resources :carts
  get 'admin/login'

  
  get 'home/index'
  post 'admin/login'
  get 'admin/logout'
  root to: 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
