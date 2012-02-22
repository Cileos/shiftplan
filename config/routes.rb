Shiftplan::Application.routes.draw do

  resources :plans do
    resources :schedulings
    get 'week/:week' => 'schedulings#index', :as => 'week', :constraints => { :week => /\d{1,2}/ }
    get ':year/week/:week' => 'schedulings#index', :as => 'year_week', :constraints => { :year => /\d{4}/, :week => /\d{1,2}/ }
  end

  resources :employees
  resources :teams do
    resource :merge, :only => [:new, :create], :controller => 'team_merge'
  end

  get "dashboard" => 'welcome#dashboard', :as => 'dashboard'
  get "dashboard" => 'welcome#dashboard', :as => 'user_root'

  devise_for :users, :controllers => { :registrations => "planners/registrations", :invitations => 'users/invitations' }

  root :to => "welcome#landing"
end
