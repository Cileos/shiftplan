ActionController::Routing::Routes.draw do |map|
  map.resource :dashboard

  map.resources :employees
  map.resources :workplaces
  map.resources :plans

  map.resources :shifts
  map.resources :requirements
  map.resources :assignments

  map.with_options :controller => 'allocations', :action => 'index' do |a|
    a.allocations_by_date  'plans/:year/:month/:day',
      :month => nil, :day => nil,
      :requirements => { :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ }
    a.allocations_by_week 'plans/weeks/:year/:week',
      :requirements => { :year => /\d{4}/, :week => /\d{1,2}/ }
  end

  map.root :controller => 'dashboard', :action => 'show'
end
