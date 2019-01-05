Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  resources :users

  root 'home#index'
  post '/', to: 'home#update', as: 'home_update'
  get  '/about', to: 'home#about'
  post '/about', to: 'home#update'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
