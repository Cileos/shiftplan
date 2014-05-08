Clockwork::Application.routes.draw do

  get 'invitation/accept'    => 'accept_invitations#accept',  :as => :accept_invitation
  put 'invitation/confirm'   => 'accept_invitations#confirm', :as => :confirm_invitation
  get 'email_change/accept'  => 'email_change#accept',        :as => :accept_email_change
  put 'email_change/confirm' => 'email_change#confirm',       :as => :confirm_email_change

  resources :notifications, only: [:index]
  put 'notifications/mark_as_seen' => 'notifications#mark_as_seen', as: 'mark_notifications_as_seen'

  get 'count_notifications'           => 'count_notifications#count',           as: 'count_notifications'
  put 'mark_notification_as_read/:id' => 'mark_notifications_as_read#one',      as: 'mark_notification_as_read'
  put 'mark_notifications_as_read'    => 'mark_notifications_as_read#multiple', as: 'mark_notifications_as_read'

  resources :accounts, except: [:show] do
    resources :reports, only: [:new]
    resources :organizations do
      resources :reports, only: [:new]

      member do
        post 'add_members'
      end

      resources :plans do
        resources :attached_documents, only: [:new, :create, :destroy]
        resources :schedulings do
          resources :comments, only: [:index, :create, :destroy], controller: 'scheduling_comments'
          resource :conflicts, only: :show
        end

        # The names should correspond with the controller actions and modes of the SchedulingFilter
        scope constraints: { week: /\d{1,2}/, cwyear: /\d{4}/ } do
          get 'week/employees/:cwyear/:week' => 'schedulings#employees_in_week', :as => 'employees_in_week'
          get 'week/teams/:cwyear/:week' => 'schedulings#teams_in_week', :as => 'teams_in_week'
          get 'week/hours/:cwyear/:week' => 'schedulings#hours_in_week', :as => 'hours_in_week'
        end

        scope constraints: { year: /\d{4}/, month: /\d{1,2}/, day: /\d{1,2}/ } do
          get 'day/teams/:year/:month/:day' => 'schedulings#teams_in_day', :as => 'teams_in_day'
        end

        resource :copy_week, only: [:new, :create], controller: :copy_week
        resource :apply_plan_template, only: [:new, :create], controller: :apply_plan_template

        resources :milestones
        # TODO nest tasks under milestones, EmberData cannot do this 2012-09-11
        resources :tasks

        # TODO force ember to fetch employees from organization, not from plan
        resources :employees
      end # plans

      resources :employees do
        collection do
          get 'adopt'
          get 'search'
        end
      end
      resources :teams
      resources :team_merges, only: [:new, :create], :controller => 'team_merges'
      resources :invitations
      resources :blogs do
        resources :posts do
          resources :comments, only: [:create, :destroy], controller: 'post_comments'
        end
      end
      resources :plan_templates do
        resources :shifts
        get 'week/teams' => 'shifts#teams_in_week', :as => 'teams_in_week'
      end

      resources :qualifications

    end # organizations

  end # accounts

  resource :user, only: :show, controller: 'user'

  # For changing password when being signed in. Use named route 'change_password' to not
  # conflict with devise's named route helper 'user_password'.
  scope '/user', as: 'change' do
    get  'password'  => 'user_password#show'
    put  'password'  => 'user_password#update'
    get  'email'     => 'user_email#show'
    put  'email'     => 'user_email#update'
  end

  resource :feedback, only: [:new, :create], :controller => 'feedback'
  scope 'profile', as: 'profile' do
    resources :employees, only: [:edit, :update, :index], controller: 'profile_employees'
  end
  resource :profile, only: [:edit, :update], controller: 'profile' do
    resource :export, only: [:show, :create, :destroy]
  end

  get "dashboard" => 'welcome#dashboard', :as => 'dashboard'
  get "dashboard" => 'welcome#dashboard', :as => 'user_root'

  get "user/:user_id/employees" => 'employees#list', :as => 'list_employees'


  scope '/feeds/:email/private-:private_token', constraints: { email: %r~[^/]+~i, private_token: /[\w]{20}/i  }  do
    get 'upcoming' => 'feeds#upcoming', as: 'upcoming_feed'
  end

  put "undo" => 'undo#update', as: 'undo'

  get '/users/sign_up', to: redirect('/signup')

  devise_for :users, :controllers => { registrations: 'signup', sessions: 'sessions'}

  devise_scope :user do
    resource :signup, controller: 'signup', only: [:show, :create]
  end

  if Rails.env.test?
    scope 'test' do
      get 'sign_in' => 'test_acceleration#sign_in', as: 'fast_sign_in'
    end
  end

  root :to => "welcome#landing"
end
