Shiftplan::Application.routes.draw do |map|
  controller :dashboard do
    resource :dashboard
  end

  resources :employees do
    resources :default_statuses
    resources :statuses
  end

  resources :workplaces
  resources :plans
  resources :qualifications

  resources :default_statuses
  resources :statuses

  resources :shifts
  resources :requirements
  resources :assignments

  resources :accounts
  resources :users

  controller :session do
    resource :session
  end

  delete '/logout', :as => :logout, :to => 'session#destroy'

  root :to => 'dashboard#show'
end
