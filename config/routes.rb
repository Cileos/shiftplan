Shiftplan::Application.routes.draw do |map|
  SprocketsApplication.routes(map)
  devise_for :users

  resource :dashboard
  resource :favorite

  resources :employees do
    collection do
      post :upload
      get  :import
    end

    resources :statuses
  end

  resources :workplaces
  resources :plans
  resources :qualifications
  resources :tags

  resources :default_statuses
  resources :statuses
  get '/statuses/:year/W:week', :as => :employees_week_statuses, :to => 'statuses#index'

  resources :shifts
  resources :requirements
  resources :assignments

  resources :accounts

  root :to => 'dashboards#show'
end
