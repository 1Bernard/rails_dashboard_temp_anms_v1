Rails.application.routes.draw do
  resources :entity_infos

  devise_scope :user do
    get "users/sign_in" => "devise/sessions#new"
    get "/users/sign_out" => "devise/sessions#destroy"
    get '/users/edit', to: 'devise/registrations#edit', as: 'edit_user_registration'
  end
  
  #errors
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  match "/422", to: "errors#unprocessable", via: :all

  root 'home#index'
  
  #roles
  get '/roles', to: 'roles#index', as: :roles
  get '/roles/new', to: 'roles#new', as: :new_role
  post '/roles', to: 'roles#create', as: :create_role
  get '/roles/:id/edit', to: 'roles#edit', as: :edit_role
  patch '/roles/:id', to: 'roles#update', as: :update_role
  get '/roles/:id/view', to:'roles#show', as: :show_role
  delete '/roles/:id/delete', to: 'roles#delete', as: :delete_role
  put '/roles/:id/update-status', to: 'roles#toggle_status', as: :toggle_status_role
  get '/roles/filter', to:'roles#filter', as: :filter_roles

  #users
  get '/users', to: 'users#index', as: :users
  get '/users/new', to: 'users#new', as: :new_user
  post '/users', to: 'users#create', as: :create_user
  get '/useers/:id/edit', to: 'users#edit', as: :edit_user
  patch '/users/:id', to: 'users#update', as: :update_user
  get '/users/:id/view', to:'users#show', as: :show_user
  delete '/users/:id/delete', to: 'users#delete', as: :delete_user
  put '/users/:id/update-status', to: 'users#toggle_status', as: :toggle_status_user
  get '/users/filter', to:'users#filter', as: :filter_users
  get '/users/export', to: 'users#export', as: :export_users

  resources :permissions_roles
  resources :permissions
  resources :user_roles
  resources :roles
  resources :users

  devise_for :users
  
  get "up" => "rails/health#show", as: :rails_health_check

end
