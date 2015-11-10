Rails.application.routes.draw do
  devise_for :users

  resources :users, only: [] do
    resources :goals, only: [:index]
  end
  # root to: "goals#index"
end
