Capitalist::Application.routes.draw do
  resources :positions
  resources :purchases, :sales
  resources :assets    
  root :to => "assets#index"
end
