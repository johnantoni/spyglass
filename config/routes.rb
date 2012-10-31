Spyglass::Application.routes.draw do

  root :to => 'searches#index'

  resources :searches
  resources :grabs

  match "empty" => "searches#empty"
  
  mount Resque::Server, :at => "/resque"  

end
