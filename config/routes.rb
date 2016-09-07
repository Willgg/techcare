Rails.application.routes.draw do

  scope '(:locale)', locale: /fr|en/ do
    root   'pages#home'
    get    'providers',          to: 'providers#index'
    post   'providers',          to: 'providers#create'
    get    'providers/callback', to: 'providers#save_token'

    devise_for :users, controllers: { registrations: "registrations", sessions: "sessions" }

    resources :users, only: [:index] do
      resources :goals, only: [:index, :new, :create, :destroy]
      resources :messages, only: [:create]
      resources :food_pictures, only: [:show, :create]
      resources :measures, only: [:create, :update]
      resources :subscriptions, only: [:edit, :destroy]
    end

    resources :messages, only: [:destroy, :index] do
      collection do
        get "/read" => "messages#read"
      end
    end

    resources :advisers, only: [:index] do
      # module indique que le controller se trouve dans /advisers, on neste pour garder adviser_id
      resource :selection, only: [:create], module: 'advisers'
    end

    resources :subscriptions, only: [:index, :new, :create]
  end

  namespace :hooks do
    namespace :stripe do
      post 'events/charge_failed', to: 'events#charge_failed', as: 'cf'
    end
  end

  post 'auth/:provider', to: 'authorizations#new', as: 'new_auth'
  get  'auth/:provider/callback', to: 'authorizations#create', as: 'auth_callback'

end
