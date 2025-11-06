Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "microsoft_graph_auth/authorize"
      get "microsoft_graph_auth/callback"
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :users, only: [:index, :show] do
        member do
          get 'profile'
          get 'application_limit'
        end
      end
      resources :departments
      resources :roles
      resources :application_statuses
      resources :applications, only: [:index, :create, :destroy]
      get 'applications/stats', to: 'applications#stats'
      get 'applications/recent', to: 'applications#recent'
      resources :approvals, only: [:index, :update]
      resources :transport_routes, only: [:index]
      resources :user_transport_routes, only: [:index, :create, :destroy]

      namespace :admin do
        resources :users, only: [:index, :create, :update, :destroy, :show]
        resources :applications, only: [:index] do
          collection do
            get 'export_csv'
          end
        end
        resources :user_info_changes, only: [:index, :create, :update, :destroy]
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
