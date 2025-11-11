Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :notifications, only: [:index, :update] do
        get :unread, on: :collection
      end
      get "microsoft_graph_auth/authorize"
      get "microsoft_graph_auth/callback"
      mount_devise_token_auth_for 'User', at: 'auth'
      get 'me', to: 'users#me'
      resources :users, only: [:index, :show, :create, :update, :destroy] do
        member do
          get 'application_limit'
        end
      end
      resources :departments
      resources :roles
      resources :groups, only: [:index]
      resources :application_statuses
      resources :applications, only: [:index, :create, :destroy, :show] do
        collection do
          get :calendar
          get :stats
          get :recent
        end
      end
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
        get 'usage_stats', to: 'usage_stats#index'
        get 'usage_stats/export', to: 'usage_stats#export'
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
