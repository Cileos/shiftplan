Shiftplan::Application.routes.draw do

  match 'invitation/accept'    => 'accept_invitations#accept',  :as => :accept_invitation
  match 'invitation/confirm'   => 'accept_invitations#confirm', :as => :confirm_invitation
  match 'email_change/accept'  => 'email_change#accept',        :as => :accept_email_change
  match 'email_change/confirm' => 'email_change#confirm',       :as => :confirm_email_change

  resources :organizations do
    resources :plans do
      resources :schedulings do
        resources :comments, only: [:index, :create, :destroy], controller: 'scheduling_comments'
      end
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
        resources :comments, only: [:create, :destroy], controller: 'post_comments'
      end
    end
  end

  resource :user, only: [:edit, :update], controller: 'user'

  resource :feedback, only: [:new, :create], :controller => 'feedback'
  scope 'profile', as: 'profile' do
    resources :employees, only: [:edit, :update, :index], controller: 'profile_employees'
  end

  get "dashboard" => 'welcome#dashboard', :as => 'dashboard'
  get "dashboard" => 'welcome#dashboard', :as => 'user_root'

  get "user/:user_id/employees" => 'employees#list', :as => 'list_employees'

  devise_for :users, :controllers => { registrations: 'planners/registrations', sessions: 'sessions'}

  if Rails.env.test?
    scope 'test' do
      get 'sign_in' => 'test_acceleration#sign_in', as: 'fast_sign_in'
    end
  end

  root :to => "welcome#landing"
end
