Shiftplan::Application.routes.draw do
  get "dashboard" => 'welcome#dashboard', :as => 'dashboard'

  devise_for :users

  root :to => "welcome#landing"
end
