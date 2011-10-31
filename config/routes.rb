Shiftplan::Application.routes.draw do

  resources :employees

  get "dashboard" => 'welcome#dashboard', :as => 'dashboard'
  get "dashboard" => 'welcome#dashboard', :as => 'user_root'

  devise_for :users

  root :to => "welcome#landing"
end
