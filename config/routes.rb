Shiftplan::Application.routes.draw do

  resources :plans do
    resources :schedulings
  end

  resources :employees

  get "dashboard" => 'welcome#dashboard', :as => 'dashboard'
  get "dashboard" => 'welcome#dashboard', :as => 'user_root'

  devise_for :users, :controllers => { :registrations => "planners/registrations" }

  root :to => "welcome#landing"
end
