Rails.application.routes.draw do
  root "pages#index", to: "pages#index", as: :root

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA routes
  # get "/login", to: "sessions#new", as: :login
  get "/login", to: redirect("/auth/google_oauth2/callback"), as: :login

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "/auth/failure", to: "sessions#failure"  # Optional, for handling failed authentication
  get "/auth/google_oauth2/callback", to: "sessions#omniauth", as: :omniauth_callback
  get "admin/dashboard", to: "admin#dashboard", as: :admin_dashboard
  get "dashboard", to: "students#dashboard", as: :students_dashboard
  get "register", to: "registrations#new"
  post "register", to: "registrations#create"
  get "schedule_viewer", to: "schedules#schedule_viewer"
  # Course and schedule routes
  resources :courses
  resources :schedules, only: [:index, :show] do
    collection do
      get "generate_schedule", to: "schedules#generate_schedule", as: :generate_schedule
    end
  end

  # User and session routes
  # User and session routes
  resources :users, only: [:new, :create, :show, :index, :edit, :update, :destroy]

  post 'users/upload', to: 'users#upload', as: 'users_upload'

  resource :session, only: [:new, :create, :destroy] do
    collection do
      get "sso_new"
      get "sso_create"
      get "/logout", to: "sessions#logout", as: "logout"
    end
  end

  # Excel file routes
  resources :excel_files

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  resources :courses do
    collection { post :upload, as: :course_upload }
  end
  get "course_uploads/:as_id", to: "courses#show_by_upload", as: :courses_by_upload

  # Defines the root path route ("/")
  # root "posts#index"

  resources :blocks do
    collection do
      post :generate
      get :preview
      post :save
      get :export
    end
  end
  # Add this line for user profile
  get "user/profile", to: "users#profile", as: :user_profile_view

  # Add this line for selecting a block
  resource :block_selection, only: [:create]
end
