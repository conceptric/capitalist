Capitalist::Application.routes.draw do
  resources :purchases
  resources :sales
  resources :assets    
  root :to => "assets#index"
end
