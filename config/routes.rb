Rails.application.routes.draw do
  root 'goals#index'

  devise_for :users, controllers: { registrations: "registrations" }

  resources :users, only: [:index] do
    resources :goals, only: [:index]
  end
  resources :goals, only: [:new, :create, :destroy]

  resources :messages, only: [:create, :destroy]

  resources :advisers, only: [:index] do
    resource :selection, only: [:create], module: 'advisers' # module permet d'indique que le controller se trouve dans le dossier adviser, on neste pour garder le id de adviser
  end
end
