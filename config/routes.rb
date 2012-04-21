Shiftplan::Application.routes.draw do

  match 'invitation/accept'  => 'accept_invitations#accept', :as => :accept_invitation
  match 'invitation/confirm' => 'accept_invitations#confirm', :as => :confirm_invitation

  resources :organizations do
    resources :plans do
      resources :schedulings
      get 'week/:week' => 'schedulings#index', :as => 'week', :constraints => { :week => /\d{1,2}/ }
      get ':year/week/:week' => 'schedulings#index', :as => 'year_week', :constraints => { :year => /\d{4}/, :week => /\d{1,2}/ }
      resource :copy_week, only: [:new, :create], controller: :copy_week
    end
    resources :employees
    resources :teams do
      resource :merge, only: [:new, :create], :controller => 'team_merge'
    end
    resources :invitations
    resources :blogs do
      resources :posts do
        resources :comments, only: [:create, :destroy]
      end
    end
  end

  resource :feedback, only: [:new, :create], :controller => 'feedback'

  get "dashboard" => 'welcome#dashboard', :as => 'dashboard'
  get "dashboard" => 'welcome#dashboard', :as => 'user_root'

  devise_for :users, :controllers => { :registrations => "planners/registrations" }

  root :to => "welcome#landing"
end
