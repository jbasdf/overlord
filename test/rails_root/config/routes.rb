ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'default', :action => 'index'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
