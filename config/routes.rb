Rails.application.routes.draw do
  root 'goals#index'

  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions" }

  resources :users, only: [:index] do
    resources :goals, only: [:index, :new, :create, :destroy]
    resources :messages, only: [:create]
  end

  resources :messages, only: [:destroy]

  resources :advisers, only: [:index] do
    resource :selection, only: [:create], module: 'advisers' # module permet d'indique que le controller se trouve dans le dossier advisers, on neste pour garder le id de adviser
  end
end
