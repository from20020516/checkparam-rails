Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users
  resources :gearsets

  root 'gearsets#index'
  get  '/about', to: 'descriptions#about'
  get  '/descriptions', to: 'descriptions#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
