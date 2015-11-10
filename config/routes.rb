Rails.application.routes.draw do
  devise_for :users

  resources :users, only: [] do
    resources :goals, only: [:index]
  end
  resources :goals, only: [:new, :create, :destroy]
  root 'goals#index'
end
