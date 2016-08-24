Rails.application.routes.draw do

  get 'subscriptions/show'

  get 'subscriptions/create'

  get 'subscriptions/destroy'

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
    end

    resources :messages, only: [:destroy, :index] do
      collection do
        get "/read" => "messages#read"
      end
    end

    resources :advisers, only: [:index] do
      resource :selection, only: [:create], module: 'advisers' # module permet d'indique que le controller se trouve dans le dossier advisers, on neste pour garder le id de adviser
    end

    resources :subscriptions, only: [:show, :new, :create, :destroy]
  end

  post 'auth/:provider', to: 'authorizations#new', as: 'new_auth'
  get  'auth/:provider/callback', to: 'authorizations#create', as: 'auth_callback'

end
