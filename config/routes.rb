Shiftplan::Application.routes.draw do

  get 'invitation/accept'    => 'accept_invitations#accept',  :as => :accept_invitation
  put 'invitation/confirm'   => 'accept_invitations#confirm', :as => :confirm_invitation
  get 'email_change/accept'  => 'email_change#accept',        :as => :accept_email_change
  put 'email_change/confirm' => 'email_change#confirm',       :as => :confirm_email_change

  resources :organizations do
    resources :plans do
      resources :schedulings do
        resources :comments, only: [:index, :create, :destroy], controller: 'scheduling_comments'
      end

      # The names should correspond with the controller actions and modes of the SchedulingFilter
      scope contraints: { week: /\d{1,2}/, year: /\d{4}/ } do
        get 'week/:week'       => 'schedulings#employees_in_week', :as => 'week'
        get 'week/:year/:week' => 'schedulings#employees_in_week', :as => 'year_week'

        get 'week/employees/:year/:week' => 'schedulings#employees_in_week', :as => 'employees_in_week'
        get 'week/teams/:year/:week' => 'schedulings#teams_in_week', :as => 'teams_in_week'
        get 'week/hours/:year/:week' => 'schedulings#hours_in_week', :as => 'hours_in_week'
      end

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

  resource :user, only: :show, controller: 'user'
  get 'user/email'  => 'user_email#show', :as => :user_email
  put 'user/email'  => 'user_email#update'
  get 'user/password'  => 'user_password#show', :as => :user_password
  put 'user/password'  => 'user_password#update'

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
