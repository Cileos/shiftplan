ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'workplaces' # temporary
  map.resources :workplaces
end
