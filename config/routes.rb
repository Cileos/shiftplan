Shiftplan::Application.routes.draw do |map|
  # controller :session do
  #   resource :session
  # end
  #
  # controller :dashboard do
  #   resource :dashboard
  # end

  resource :session
  resource :dashboard
  resource :favorite

  resources :employees do
    resources :statuses
  end

  resources :workplaces
  resources :plans
  resources :qualifications
  resources :tags

  resources :default_statuses
  resources :statuses

  resources :shifts
  resources :requirements
  resources :assignments

  resources :accounts
  resources :users

  delete '/logout', :as => :logout, :to => 'session#destroy'

  root :to => 'dashboards#show'
end
