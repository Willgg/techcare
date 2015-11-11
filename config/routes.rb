Rails.application.routes.draw do
  devise_for :users

  resources :users, only: [:index] do
    resources :goals, only: [:index]
  end
  resources :goals, only: [:new, :create, :destroy]

  resources :messages, only: [:create, :destroy]

  root 'goals#index'
end
