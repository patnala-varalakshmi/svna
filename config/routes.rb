Rails.application.routes.draw do
  root 'static_pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post "sign_up", to: "users#create"
  get "sign_up", to: "users#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "login", to: "sessions#new"
  resources :confirmations, only: [:create, :edit, :new], param: :confirmation_token
  resources :passwords, only: [:create, :edit, :new, :update], param: :password_reset_token
end
