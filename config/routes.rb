# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users
  resources :gearsets

  root 'gearsets#index'
  get  '/about', to: 'users#about'
  get  '/descriptions', to: 'gearsets#descriptions'
end
