ActionController::Routing::Routes.draw do |map|
  map.resources :allocations

  map.resources :employees

  map.root :controller => 'workplaces' # temporary
  map.resources :workplaces

  map.with_options :controller => 'allocations', :action => 'index' do |a|
    a.allocation_by_day  'plans/:year/:month/:day',
      :month => nil, :day => nil,
      :requirements => { :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ }
    a.allocation_by_week 'plans/weeks/:year/:week',
      :requirements => { :year => /\d{4}/, :week => /\d{1,2}/ }
  end
end
